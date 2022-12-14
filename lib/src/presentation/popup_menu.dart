import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_exam_flutter_lostcats/src/application/firebase_providers.dart';

import 'login_page.dart';

class PopupMenu extends ConsumerWidget {
  const PopupMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authStateChangesProvider);
    var firebase = ref.read(firebaseAuthProvider);

    var loggedIn = false;
    firebase.currentUser != null ? loggedIn = true : loggedIn = false;

    var status = "";
    loggedIn ? status = "Logout" : status = "Login";

    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(value: 0, child: Text(status)),
          const PopupMenuItem<int>(value: 1, child: Text('Settings')),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case 0:
            {
              if (loggedIn == false) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage(title: 'Login page',)));
              } else {
                firebase.signOut();
              }
            }
            break;

          case 1:
            {
              debugPrint("Settings placeholder clicked");
            }
            break;

          default: {
            debugPrint("Unhandled action in PopupMenuItem");
          }
        }
      },
    );
  }
}
