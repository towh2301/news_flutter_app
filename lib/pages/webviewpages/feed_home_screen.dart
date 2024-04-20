import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_flutter_app/common/rss_list.dart';
import 'package:news_flutter_app/pages/webviewpages/webfeed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Initialize the list of websites
  final List<Map<String, String>> websites = RssMapFile().rssMap;
  final websiteMap = WebsitesList().websList;
  late Map<String, String>? _categories;
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

  // _getCategories(int index) {
  //   Map<String, String> categories = {};
  //   categories = websites[index];
  //   return categories;
  // }

  @override
  void initState() {
    super.initState();
    _categories = websites[1];
    _url = _categories!.values.elementAt(1);
    _category = _categories!.keys.elementAt(1);
    _websiteName = websiteMap.keys.elementAt(1);
  }

  Drawer sideBarCustom(context, Map websiteMap) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 39, 38, 38),
                //shape: BoxShape.rectangle,
              ),
              child: Text(
                'List of Websites',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
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
                  color: Color.fromARGB(255, 0, 0, 0),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
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
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 10),
              scrollDirection: Axis.horizontal,
              itemCount: _categories?.length,
              itemBuilder: (context, index) {
                final category = _categories?.keys.elementAt(index);
                final url = _categories?[category];
                final isSelected = (_selectedIndex == index);
                return Row(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                      child: InkWell(
                        onTap: () {
                          navigateBottomBar(index, url!, category);
                        },
                        child: Container(
                          width: category!.length * 12.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isSelected
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : Colors.white,
                          ),
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            category,
                            textAlign: TextAlign.center,
                            //textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 12,
            child: FutureBuilder(
              future: webFeedView(_url, _category),
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

  Future<void> logout() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pop();
      return FirebaseAuth.instance.signOut();
    } else {
      throw Exception('No user found');
    }
  }

  List<String> getVisibleProviders(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final linkedProviders =
        user.providerData.map((provider) => provider.providerId).toList();
    return linkedProviders
        .where((provider) => provider != 'google.com')
        .toList(); // Hide Google provider
  }

  void goToProfile(context) {
    Navigator.push(
      context,
      MaterialPageRoute<ProfileScreen>(
        builder: (context) => ProfileScreen(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: const Text(
              'Profile',
              textAlign: TextAlign.left,
            ),
          ),
          avatarPlaceholderColor: Colors.blue[600],
          showMFATile: false,
          actions: [
            SignedOutAction((context) {
              Navigator.of(context).pop();
            })
          ],
        ),
      ),
    );
  }
}
