import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_flutter_app/common/rss_list.dart';
import 'package:news_flutter_app/pages/webviewpages/webfeed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // For now, I just have one list of websites: websites[0]
  // I will config for multiple list of websites later

  final List<Map<String, String>> websites = RssMapFile().rssMap;
  final websiteMap = WebsitesList().websList;
  Map<String, String>? _categories;
  late String _websiteName = '';

  // Set index for page
  int _selectedIndex = 0;
  String _url = '';
  String _category = '';

  void navigateBottomBar(int index, String url, String category) {
    setState(() {
      _selectedIndex = index;
      _url = url;
      _category = category;
    });
  }

  @override
  void initState() {
    super.initState();
    _categories = _getCategories();
    _url = _categories!.values.elementAt(0);
    _category = _categories!.keys.elementAt(0);
    _websiteName = websiteMap.keys.elementAt(0);
  }

  Drawer sideBarCustom(context, Map websiteMap) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
              ),
              child: Text(
                'List of Websites',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          for (var website in websiteMap.entries)
            ListTile(
              title: Text(
                website.key,
                style: const TextStyle(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                setState(() {
                  _websiteName = website.key;
                  _categories = website.value;
                  _url = _categories!.values.elementAt(0);
                  _category = _categories!.keys.elementAt(0);
                });
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }

  _getCategories() {
    Map<String, String> categories = {};
    categories = websites[0];
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _websiteName,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => goToProfile(context),
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10, left: 10),
              scrollDirection: Axis.horizontal,
              itemCount: _categories?.length,
              itemBuilder: (context, index) {
                final category = _categories?.keys.elementAt(index);
                final url = _categories?[category];
                final isSelected = (_selectedIndex == index);
                return Row(
                  children: <Widget>[
                    Container(
                      width: 130,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isSelected ? Colors.blue : Colors.white),
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 10),
                      child: ListTile(
                        title: Text(
                          textAlign: TextAlign.center,
                          category ?? '',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        splashColor: Colors.white,
                        onTap: () {
                          navigateBottomBar(index, url!, category!);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 7,
            child: FutureBuilder(
              future: webFeedView(_url, _category),
              //future: webFeedViewTest(_url, _category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return snapshot.data!;
                }
              },
            ),
          ),
        ],
      ),
      drawer: sideBarCustom(context, websiteMap),
    );
  }

  void goToProfile(context) {
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
  }
}
