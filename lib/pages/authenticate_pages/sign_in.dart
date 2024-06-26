import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_flutter_app/models/data/bookmarks_model.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:news_flutter_app/pages/homepages/main_home_screen.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    // This is for the authentication gate
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          MyData.bookmarksMap.clear();
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(
                clientId:
                    "695246035916-6f5p3dohskq2rn7pqtm78r6bfjc9k7mh.apps.googleusercontent.com",
                scopes: List.of([
                  'email',
                  'https://www.googleapis.com/auth/contacts.readonly',
                ]),
              ),
              // FacebookProvider(
              //   clientId: 'f51edc50c1aa5b147042ad092ceee8e0',
              //   redirectUri:
              //       'https://www.facebook.com/connect/login_success.html',
              // ),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/images/login.png'),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                // child: action == AuthAction.signIn
                //     ? const Text('Welcome to my app, please sign in!')
                //     : const Text('Welcome to my app, please sign up!'),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                // child: Text(
                //   'By signing in, you agree to our Terms of Service and Privacy Policy.',
                //   style: Theme.of(context).textTheme.titleSmall,
                //   textAlign: TextAlign.left,
                // ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/images/verify.png'),
                ),
              );
            },
          );
        }
        return const MainScreen();
      },
    );
  }
}

// Future<UserCredential?> signInWithFacebook() async {
//   final LoginResult result = await FacebookAuth.instance.login();
//   if (result.status == LoginStatus.success) {
//     // Create a credential from the access token
//     final OAuthCredential credential =
//         FacebookAuthProvider.credential(result.accessToken!.token);
//     // Once signed in, return the UserCredential
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
//   return null;
// }
