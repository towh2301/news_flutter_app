import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_flutter_app/pages/webviewpages/webview.dart';
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
  // Initialize feed and title
  // static const feedLoadErrorMsg = 'Failed to load feed';
  // static const feedLoadSuccessMsg = 'Feed loaded successfully';
  // static const feedLoadMsg = 'Loading feed...';
  static const placeholderImage = 'assets/images/placeholder.png';
  late GlobalKey<RefreshIndicatorState> _refreshKey;
  late String imageUrl;

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
    if (imageUrl == 'null') {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Image.asset(
          placeholderImage,
          height: 70,
          width: 80,
          alignment: Alignment.center,
          fit: BoxFit.fill,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: CachedNetworkImage(
          placeholder: (context, url) => Image.asset(placeholderImage),
          imageUrl: imageUrl,
          height: 70,
          width: 80,
          alignment: Alignment.center,
          fit: BoxFit.fill,
        ),
      );
    }
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
  rightIcon() {
    bool isClicked = false;
    return GestureDetector(
      onTap: () {
        setState(() {
          isClicked = !isClicked;
        });
      },
      child: setRightIcon(isClicked),
    );
  }

  setRightIcon(isClicked) {
    return isClicked
        ? const Icon(Icons.star)
        : const Icon(Icons.star_border_outlined);
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
              var imageUrl = snapshot.data ?? 'null';
              if (imageUrl.toString().startsWith('data')) {
                imageUrl = 'null';
              }
              return ListTile(
                leading: thumbnail(item.enclosure?.url ?? imageUrl ?? 'null'),
                title: title(item.title, item.link ?? ' '),
                subtitle: subtitle(item.link ?? '\n${item.pubDate}'),
                trailing: rightIcon(),
                contentPadding: const EdgeInsets.all(10.0),
                onTap: () async {
                  setState(() {});
                  openFeed(item.link ?? '', item.title ?? '');
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

      print('Image URL: ${imgElement.attributes['src']}');
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
          category: widget.category,
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RssItem>>(
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
    );
  }
}

Future<Widget> webFeedView(String url, String category) async {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Center(child: _WebFeed(url, category)),
  );
}
