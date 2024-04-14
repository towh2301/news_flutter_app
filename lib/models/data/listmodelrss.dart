import 'package:flutter/material.dart';

class ListModelRSS {
  List<RSSItem> items;

  ListModelRSS({required this.items});

  factory ListModelRSS.fromJson(Map<String, dynamic> json) {
    List<RSSItem> items = [];
    if (json['items'] != null) {
      json['items'].forEach((item) {
        items.add(RSSItem.fromJson(item));
      });
    }
    return ListModelRSS(items: items);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['items'] = items.map((item) => item.toJson()).toList();
    return data;
  }
}

class RSSItem {
  String title;
  String description;
  String link;
  String pubDate;
  Image? image;

  RSSItem({
    required this.title,
    required this.description,
    required this.link,
    required this.image,
    required this.pubDate, // Add an initializer expression for the 'pubDate' field
  });

  factory RSSItem.fromJson(Map<String, dynamic> json) {
    return RSSItem(
      title: json['title'],
      description: json['description'],
      link: json['link'],
      image: json['image'],
      pubDate: json['pubDate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['link'] = link;
    data['image'] = image;
    data['pubDate'] = pubDate;
    return data;
  }
}
