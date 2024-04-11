import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_flutter_app/pages/homepages/webfeed.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      body: const WebFeed(),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       SizedBox(
      //         height: 100,
      //         child: Card(
      //           // clipBehavior is necessary because, without it, the InkWell's animation
      //           // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
      //           // This comes with a small performance cost, and you should not set [clipBehavior]
      //           // unless you need it.
      //           clipBehavior: Clip.hardEdge,
      //           child: InkWell(
      //             splashColor: Colors.blue.withAlpha(30),
      //             onTap: () {
      //               debugPrint('Card tapped.');
      //             },
      //             child: const SizedBox(
      //               width: 300,
      //               height: 100,
      //               child: Text('A card that can be tapped'),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
