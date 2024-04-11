import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed_revised/webfeed_revised.dart';

Future<List<RssItem>> fetchRssFeed(String url) async {
  final response = await http.get(Uri.parse(url));
  final feed = RssFeed.parse(response.body);

  return feed.items?.map((item) {
        return RssItem(
          title: item.title ?? '',
          link: item.link ?? '',
          pubDate: item.pubDate ?? DateTime.now(),
        );
      }).toList() ??
      [];
}

class _WebFeed extends StatefulWidget {
  final String url;
  const _WebFeed(this.url, {Key? key}) : super(key: key);

  @override
  State<_WebFeed> createState() => _WebFeedState();
}

class _WebFeedState extends State<_WebFeed> {
  late Future<List<RssItem>> _rssItems;

  @override
  void initState() {
    super.initState();
    _rssItems = fetchRssFeed(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RssItem>>(
      future: _rssItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final rssItems = snapshot.data!;
          return ListView.builder(
            itemCount: rssItems.length,
            itemBuilder: (context, index) {
              final item = rssItems[index];
              return ListTile(
                title: Text(item.title ?? ''),
                subtitle: Text(item.link ?? ''),
                trailing: Text(item.pubDate.toString()),
              );
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

class WebFeedView extends StatefulWidget {
  final String url, category;
  const WebFeedView(this.category, this.url, {super.key});

  @override
  State<WebFeedView> createState() => _WebFeedViewState();
}

class _WebFeedViewState extends State<WebFeedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(child: _WebFeed(widget.url)),
    );
  }
}
