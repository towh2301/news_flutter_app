// Step 2: Import necessary packages
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed_revised/webfeed_revised.dart';

// Step 3: Function to fetch and parse RSS
Future<RssFeed> fetchRssFeed(String url) async {
  final response = await http.get(Uri.parse(url));
  return RssFeed.parse(response.body);
}

// Step 4 & 5: In the build method
@override
Widget build(BuildContext context) {
  return FutureBuilder<RssFeed>(
    future: fetchRssFeed(
        'https://example.com/rss'), // replace with your RSS feed URL
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
