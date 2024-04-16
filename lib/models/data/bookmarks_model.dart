import 'package:news_flutter_app/models/data/listmodelrss.dart';

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

// Should be initialized with the data from the database
class MyData {
  static Map<String, RSSItem> bookmarksMap = {};

  static void initializeData() {
    bookmarksMap = {};
  }

  static void addBookmark(RSSItem item) {
    bookmarksMap[item.id] = item;
  }

  static void removeBookmark(RSSItem item) {
    bookmarksMap.remove(item.id);
  }

  static bool isBookmarked(RSSItem item) {
    return bookmarksMap.containsKey(item.id);
  }

  static List<RSSItem> getBookmarks() {
    return bookmarksMap.values.toList();
  }

  static void clearBookmarks() {
    bookmarksMap = {};
  }

  static void toggleBookmark(RSSItem item) {
    if (isBookmarked(item)) {
      removeBookmark(item);
    } else {
      addBookmark(item);
    }
  }

  static void saveBookmarks() {
    // Save bookmarks to the database with the user id
  }
}
