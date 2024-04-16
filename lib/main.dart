import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_flutter_app/common/theme.dart';
import 'package:news_flutter_app/firebase_options.dart';
import 'package:news_flutter_app/pages/authenticate_pages/sign_in.dart';
import 'package:news_flutter_app/pages/onboardpages/onboard_screens.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: checkAuth(),
      routes: {
        '/onboarding': (context) => const OnBoardingScreen(),
        '/authgate': (context) => const SignInScreen(),
      },
    );
  }
}

Widget checkAuth() {
  if (FirebaseAuth.instance.currentUser != null) {
    return (const SignInScreen());
  } else {
    return (const OnBoardingScreen());
  }
}
