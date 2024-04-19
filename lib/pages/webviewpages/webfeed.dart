import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_flutter_app/models/data/bookmarks_model.dart';
import 'package:news_flutter_app/models/data/listmodelrss.dart';
import 'package:news_flutter_app/pages/webviewpages/webview.dart';
import 'package:tiengviet/tiengviet.dart';
import 'package:webfeed_revised/webfeed_revised.dart';
import 'package:html/parser.dart' as parser;

class _WebFeed extends StatefulWidget {
  final String url, category;
  const _WebFeed(this.url, this.category);

  @override
  State<_WebFeed> createState() => _WebFeedState();
}

class _WebFeedState extends State<_WebFeed> {
  late Future<List<RssItem>> _rssItems;
  static const placeholderImage = 'assets/images/placeholder.png';
  late GlobalKey<RefreshIndicatorState> _refreshKey;
  late String imageUrl;
  late int bookmarkIndex = 0;
  late Map<String, RSSItem> rssItemsMap = {};
  late User? _user;

  // Load feed with error handling
  Future<RssFeed> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(widget.url));
      return RssFeed.parse(response.body);
    } catch (e) {
      throw Exception('Failed to load feed');
    }
  }

  // Fetch RSS feed
  Future<List<RssItem>> fetchRssFeed(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final feed = RssFeed.parse(response.body);
      return feed.items?.map((item) {
            return RssItem(
              title: item.title ?? '',
              link: item.link ?? '',
              pubDate: item.pubDate ?? DateTime.now(),
              enclosure: item.enclosure,
            );
          }).toList() ??
          [];
    } catch (e) {
      throw Exception('Failed to fetch RSS feed');
    }
  }

  // Load thumbnail
  thumbnail(imageUrl) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 0, 0, 0),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: SizedBox.fromSize(
          size: const Size.fromRadius(40),
          child: imageUrl == 'null'
              ? Image.asset(
                  placeholderImage,
                  height: 70,
                  width: 80,
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                )
              : CachedNetworkImage(
                  placeholder: (context, url) => Image.asset(placeholderImage),
                  imageUrl: imageUrl,
                  height: 80,
                  width: 80,
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                ),
        ),
      ),
    );
  }

  // Load title
  title(title, url) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Load subtitle
  subtitle(subTitle) {
    return Text(
      subTitle,
      style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w200),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Load right icon
  rightIcon(int index, RSSItem item) {
    bool isClicked = false;
    return GestureDetector(
      onTap: () {
        setState(() {
          setBookmarkIndex(index, item);
        });
      },
      child: setRightIcon(isClicked, index, item),
    );
  }

  setRightIcon(isClicked, index, RSSItem item) {
    return MyData.isBookmarked(item)
        ? const Icon(
            Icons.bookmark,
            color: Color.fromARGB(255, 0, 0, 0),
            size: 25.0,
          )
        : const Icon(
            Icons.bookmark_border,
            color: Color.fromARGB(255, 0, 0, 0),
            size: 25.0,
          );
  }

  // Set bookmark index
  setBookmarkIndex(int index, RSSItem item) {
    bookmarkIndex = index;
    MyData.toggleBookmark(item, _user!);
  }

  // Load list
  list(rssItems) {
    return ListView.builder(
      itemCount: rssItems.length,
      itemBuilder: (context, index) {
        var item = rssItems[index];
        return FutureBuilder(
          future: fetchImageFromPage(item.link ?? ''),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Load image URL
              var imageUrl = item.enclosure?.url ?? snapshot.data ?? 'null';
              if (imageUrl.toString().startsWith('data')) {
                imageUrl = 'null';
              }

              // Generate unique ID
              var id =
                  TiengViet.parse(item.title).toLowerCase().replaceAll(' ', '');

              // Create RSS item
              RSSItem rssItem = RSSItem(
                id: id,
                title: item.title ?? 'null',
                description: item.description ?? 'null',
                link: item.link ?? 'null',
                pubDate: item.pubDate.toString(),
                imageLink: imageUrl ?? 'null',
              );

              // Add RSS item to map
              rssItemsMap[id] = rssItem;

              return ListTile(
                leading: thumbnail(imageUrl),
                title: title(rssItem.title, rssItem.link),
                subtitle: subtitle(rssItem.link),
                trailing: rightIcon(index, rssItem),
                contentPadding: const EdgeInsets.all(10.0),
                onTap: () async {
                  setState(() {});
                  openFeed(rssItem.link, rssItem.title);
                },
              );
            }
          },
        );
      },
    );
  }

  dynamic fetchImageFromPage(url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final document = parser.parse(response.body);
      final imgElement = document.getElementsByTagName('img').first;
      return imgElement.attributes['src'].toString();
    } catch (e) {
      throw Exception('Failed to fetch image');
    }
  }

  // Open feed
  Future<void> openFeed(url, title) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyWebView(
          url: url,
          title: 'Feed',
        ),
      ),
    );
    debugPrint('Tapped on $url');
  }

  @override
  void initState() {
    super.initState();
    _rssItems = fetchRssFeed(widget.url);
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FutureBuilder<List<RssItem>>(
        future: _rssItems,
        builder: (context, snapshot) {
          // Check if snapshot has data
          if (snapshot.hasData) {
            final rssItems = snapshot.data!;

            // Load feed with method
            return RefreshIndicator(
              key: _refreshKey,
              child: list(rssItems),
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
                setState(() {
                  _rssItems = fetchRssFeed(widget.url);
                });
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

Future<Widget> webFeedView(String url, String category) async {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Center(child: _WebFeed(url, category)),
  );
}
