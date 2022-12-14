import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/popup_menu.dart';

import '../application/firebase_providers.dart';
import '../domain/cat.dart';

final usernameController = TextEditingController();
final passwordController = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class LoginButton extends ConsumerWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authStateChangesProvider);
    var firebase = ref.read(firebaseAuthProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: SizedBox(
        width: 200,
        height: 42,
        child: ElevatedButton(
          onPressed: () async {
            try {
              final credential = await firebase.signInWithEmailAndPassword(
                  email: usernameController.text,
                  password: passwordController.text);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                debugPrint('No user found for that email.');
              } else if (e.code == 'wrong-password') {
                debugPrint('Wrong password provided for that user.');
              }
            }
            firebase.currentUser?.reload();
            if (firebase.currentUser?.email.toString() ==
                usernameController.text) {
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: const [PopupMenu()],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 128 + 64, left: 8, right: 8, bottom: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Username',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                LoginButton(),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: GestureDetector(
                        onTap: () {
                          //TODO: IMPLEMENT REGISTER
                        },
                        child: const Text("Register"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
