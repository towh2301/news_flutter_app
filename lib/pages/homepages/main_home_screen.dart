import 'package:flutter/material.dart';
import 'package:news_flutter_app/common/navbar.dart';
import 'package:news_flutter_app/pages/homepages/bookmarkscreen.dart';
import 'package:news_flutter_app/pages/homepages/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Index for the bottom navigation bar
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Initialize the index
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const BookmarkScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: MyGNavbar(
          onTabChange: (index) => navigateBottomBar(index),
        ),
        body: _widgetOptions[_selectedIndex]);
  }
}
