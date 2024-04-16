import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_flutter_app/models/data/listmodelrss.dart';

// Should be initialized with the data from the database
class MyData {
  static Map<String, RSSItem> bookmarksMap = {};

  static void initializeData(User user) async {
    // Get bookmarks from the database
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    print('User id: ${user.email}');
    await firestore
        .collection('bookmarks')
        .where('userEmail', isEqualTo: user.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        RSSItem item = RSSItem.fromJson(doc.data() as Map<String, dynamic>);
        addBookmark(item);
      }
    });
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

  static void toggleBookmark(RSSItem item, User user) {
    if (isBookmarked(item)) {
      removeBookmark(item);
      removeBookmarkFromFirebase(user, item);
    } else {
      addBookmark(item);
      addBookmarkToFirebase(user, item);
    }
  }

  static void removeBookmarkFromFirebase(User user, RSSItem item) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('bookmarks')
        .where('userEmail', isEqualTo: user.email)
        .where('newsId', isEqualTo: item.id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  static void addBookmarkToFirebase(User user, RSSItem item) {
    // Add the bookmark
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('bookmarks').add({
      'userEmail': user.email,
      'newsId': item.id,
      'title': item.title,
      'description': item.description,
      'link': item.link,
      'imageLink': item.imageLink,
      'pubDate': item.pubDate,
    });
  }
}
