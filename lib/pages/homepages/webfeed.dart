import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed_revised/webfeed_revised.dart';

Future<RssFeed> fetchRssFeed(String url) async {
  final response = await http.get(Uri.parse(url));
  return RssFeed.parse(response.body);
}

class WebFeed extends StatefulWidget {
  const WebFeed({super.key});

  @override
  State<WebFeed> createState() => _WebFeedState();
}

class _WebFeedState extends State<WebFeed> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RssFeed>(
      future: fetchRssFeed(
          'https://nhandan.vn/rss/home.rss'), // replace with your RSS feed URL
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.items?.length,
            itemBuilder: (context, index) {
              final item = snapshot.data?.items?[index];
              return ListTile(
                title: Text(item?.title ?? ''),
                subtitle: Text(item?.link ?? ''),
                trailing: Text(item?.pubDate.toString() ?? ''),
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
