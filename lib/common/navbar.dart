import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyGNavbar extends StatelessWidget {
  final void Function(int)? onTabChange;
  const MyGNavbar({required this.onTabChange, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GNav(
        backgroundColor: Colors.white,
        activeColor: Colors.black,
        color: Colors.grey[500],
        tabBackgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        tabBorderRadius: 16,
        tabMargin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        onTabChange: ((value) => onTabChange!(value)),
        tabs: const [
          GButton(icon: Icons.home, text: '  Home  '),
          GButton(icon: Icons.bookmark, text: 'Bookmark'),
        ],
      ),
    );
  }
}
