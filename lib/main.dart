import 'package:flutter/material.dart';
import 'package:news_flutter_app/common/theme.dart';
import 'package:news_flutter_app/pages/onboardpages/onboard_screens.dart';

void main(List<String> args) {
  runApp(const MyNewsApp());
}

class MyNewsApp extends StatelessWidget {
  const MyNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News',
      debugShowCheckedModeBanner: false,
      theme: myTheme1,
      home: const OnBoardingScreen(),
    );
  }
}
