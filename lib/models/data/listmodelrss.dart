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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['items'] = this.items.map((item) => item.toJson()).toList();
    return data;
  }
}

class RSSItem {
  String title;
  String description;
  String link;

  RSSItem({required this.title, required this.description, required this.link});

  factory RSSItem.fromJson(Map<String, dynamic> json) {
    return RSSItem(
      title: json['title'],
      description: json['description'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['link'] = this.link;
    return data;
  }
}
