import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_flutter_app/common/rss_list.dart';
import 'package:news_flutter_app/models/data/categories_model.dart';
import 'package:news_flutter_app/pages/homepages/webfeed.dart';

class HomeNewsRssScreen extends StatefulWidget {
  const HomeNewsRssScreen({super.key});

  @override
  State<HomeNewsRssScreen> createState() => _HomeNewsRssScreenState();
}

class _HomeNewsRssScreenState extends State<HomeNewsRssScreen> {
  // For now, I just have one list of websites: websites[0]
  // I will config for multiple list of websites later

  final List<Map<String, String>> websites = RssMapFile().rssMap;

  Map<String, String>? _categories;

  @override
  void initState() {
    super.initState();
    _categories = _getCategories();
  }

  _getCategories() {
    Map<String, String> categories = {};
    categories = websites[0];
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text(
                        'Profile',
                        textAlign: TextAlign.left,
                      ),
                    ),
                    avatarPlaceholderColor: Colors.blue[600],
                    actions: [
                      SignedOutAction(
                        (context) {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset('assets/images/verify.png'),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.person),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _categories?.length,
          itemBuilder: (context, index) {
            final category = _categories?.keys.elementAt(index);
            final url = _categories?[category];
            return ListTile(
              title: Text(category ?? ''),
              onTap: () {
                // Navigate to the RSS feed screen for the selected category
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WebFeedView(category ?? '', url ?? ''),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
