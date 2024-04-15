import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:webfeed_revised/domain/rss_feed.dart';
import 'package:http/http.dart' as http;

class MyRSSFeed extends StatefulWidget {
  final String url, category;

  const MyRSSFeed(this.url, this.category, {super.key});

  @override
  State<MyRSSFeed> createState() => _MyRSSFeedState();
}

class _MyRSSFeedState extends State<MyRSSFeed> {
  // Initialize feed and title
  late RssFeed _feed;
  late String _title;
  static const feedLoadErrorMsg = 'Failed to load feed';
  static const feedLoadSuccessMsg = 'Feed loaded successfully';
  static const feedLoadMsg = 'Loading feed...';
  late GlobalKey<RefreshIndicatorState> _refreshKey;

  // Update feed
  void updateFeed(RssFeed feed) {
    setState(() {
      _feed = feed;
    });
  }

  // Update title
  void updateTitle(String title) {
    setState(() {
      _title = title;
    });
  }

  // Load
  load() async {
    loadFeed().then((result) {
      if (result.toString().isEmpty) {
        updateTitle(feedLoadErrorMsg);
        return;
      }
      updateFeed(result);
      updateTitle(_feed.title ?? feedLoadSuccessMsg);
    });
  }

  title(title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    return Text(
      subTitle,
      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  thumbnail(imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset(Icons.image.toString()),
        imageUrl: imageUrl,
        height: 50,
        width: 70,
        alignment: Alignment.center,
        fit: BoxFit.fill,
      ),
    );
  }

  rightIcon() {
    return const Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  list() {
    return ListView.builder(
      itemCount: _feed.items?.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _feed.items?[index];
        return ListTile(
          title: title(item?.title),
          subtitle: subtitle(item?.pubDate.toString()),
          leading: thumbnail(item!.enclosure?.url),
          trailing: rightIcon(),
          contentPadding: const EdgeInsets.all(5.0),
          onTap: () => ('openFeed(item.link)'),
        );
      },
    );
  }

  isFeedEmpty() {
    return null == _feed.items;
  }

  body() {
    return isFeedEmpty()
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            child: list(),
            onRefresh: () => load(),
            key: _refreshKey,
          );
  }

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

  // Init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateTitle(feedLoadMsg);
    load();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: body(),
    );
  }
}

Future<Widget> webFeedViewTest(String url, String category) async {
  return MyRSSFeed(url, category);
}
