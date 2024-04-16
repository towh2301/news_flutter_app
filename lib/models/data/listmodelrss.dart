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
  String id;
  String title;
  String description;
  String link;
  String pubDate;
  String imageLink;

  RSSItem({
    required this.id,
    required this.title,
    required this.description,
    required this.link,
    required this.imageLink,
    required this.pubDate, // Add an initializer expression for the 'pubDate' field
  });

  factory RSSItem.fromJson(Map<String, dynamic> json) {
    return RSSItem(
      id: json['newsId'],
      title: json['title'],
      description: json['description'],
      link: json['link'],
      pubDate: json['pubDate'],
      imageLink: json['imageLink'] ?? 'null',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['link'] = link;
    data['imageLink'] = imageLink;
    data['pubDate'] = pubDate;
    return data;
  }
}
