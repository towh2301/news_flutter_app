class Bookmark {
  final String id;
  final String userId;
  final String newsId;

  Bookmark(this.id, this.userId, this.newsId);

  Bookmark.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        newsId = json['newsId'];
}
