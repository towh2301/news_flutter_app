import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_flutter_app/models/data/bookmarks_model.dart';
import 'package:news_flutter_app/models/data/listmodelrss.dart';
import 'package:news_flutter_app/pages/webviewpages/webview.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  static const placeholderImage = 'assets/images/placeholder.png';
  late User? _user;

// Load thumbnail
  thumbnail(imageUrl) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 0, 0, 0),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: SizedBox.fromSize(
          size: const Size.fromRadius(40),
          child: imageUrl == 'null'
              ? Image.asset(
                  placeholderImage,
                  height: 70,
                  width: 80,
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                )
              : CachedNetworkImage(
                  placeholder: (context, url) => Image.asset(placeholderImage),
                  imageUrl: imageUrl,
                  height: 80,
                  width: 80,
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                ),
        ),
      ),
    );
  }

  // Load title
  title(title, url) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Load subtitle
  subtitle(subTitle) {
    return Text(
      subTitle,
      style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w200),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Load right icon
  rightIcon(RSSItem item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          setBookmarkIndex(item);
        });
      },
      child: setRightIcon(item),
    );
  }

  setRightIcon(RSSItem item) {
    return MyData.isBookmarked(item)
        ? const Icon(Icons.bookmark, color: Colors.blue)
        : const Icon(Icons.bookmark_border, color: Colors.blue);
  }

  // Set bookmark index
  setBookmarkIndex(RSSItem item) {
    MyData.toggleBookmark(item, _user!);
  }

  // Open feed
  Future<void> openFeed(url, title) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyWebView(
          url: url,
          title: 'Feed',
        ),
      ),
    );
    debugPrint('Tapped on $url');
  }

  // Load list
  list(Map<String, RSSItem> rssItems) {
    return ListView.builder(
      itemCount: rssItems.length,
      itemBuilder: (context, index) {
        RSSItem rssItem = rssItems.values.elementAt(index);
        return ListTile(
          leading: thumbnail(rssItem.imageLink),
          title: title(rssItem.title, rssItem.link),
          subtitle: subtitle(rssItem.link),
          trailing: rightIcon(rssItem),
          contentPadding: const EdgeInsets.all(10.0),
          onTap: () async {
            openFeed(rssItem.link, rssItem.title);
          },
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    MyData.initializeData(_user!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Bookmark',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: list(MyData.bookmarksMap),
        ));
  }
}
