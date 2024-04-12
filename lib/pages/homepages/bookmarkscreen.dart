import 'package:flutter/material.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

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
      body: const Center(
        child: Text('Bookmark Screen'),
      ),
    );
  }
}
