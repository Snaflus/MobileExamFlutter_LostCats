import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_exam_flutter_lostcats/src/data/firebase_providers.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/settings_page.dart';

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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage(title: 'Login page',)));
              } else {
                firebase.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            }
            break;

          case 1:
            {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage(title: 'Settings page',)));
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
