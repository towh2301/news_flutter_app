import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_flutter_app/pages/webviewpages/webview.dart';
import 'package:webfeed_revised/webfeed_revised.dart';

Future<List<RssItem>> fetchRssFeed(String url) async {
  final response = await http.get(Uri.parse(url));
  final feed = RssFeed.parse(response.body);

  return feed.items?.map((item) {
        return RssItem(
          title: item.title ?? '',
          link: item.link ?? '',
          pubDate: item.pubDate ?? DateTime.now(),
          media: item.media,
        );
      }).toList() ??
      [];
}

class _WebFeed extends StatefulWidget {
  final String url, category;
  const _WebFeed(this.url, this.category, {super.key});

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
                leading: item.media != null
                    ? const Icon(Icons.image, size: 40)
                    : null,
                title: GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WebViewWidget(
                          url: item.link ?? '',
                          category: widget.category,
                          title: item.title ?? '',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    item.title ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                subtitle: Text(
                  item.link ?? '\n${item.pubDate}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                isThreeLine: true,
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

Future<Widget> webFeedView(String url, String category) async {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Center(child: _WebFeed(url, category)),
  );
}
