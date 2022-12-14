import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/popup_menu.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/register_page.dart';

import '../data/firebase_providers.dart';
import '../domain/cat.dart';

final usernameController = TextEditingController();
final passwordController = TextEditingController();
final _formKey = GlobalKey<FormState>();

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
    ref.watch(authStateChangesProvider); //listens and rebuilds widget
    var firebase = ref.read(firebaseAuthProvider); //used to pass functions

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: SizedBox(
        width: 200,
        height: 42,
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                final credential = await firebase.signInWithEmailAndPassword(
                    email: usernameController.text,
                    password: passwordController.text);
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'user-not-found':
                    {
                      debugPrint('No user found for that email.');
                    }
                    break;

                  case 'wrong-password':
                    {
                      debugPrint('Wrong password provided for that user.');
                    }
                    break;

                  default:
                    {
                      debugPrint('Unexpected FirebaseAuthException in login');
                    }
                    break;
                }
              }
              firebase.currentUser?.reload();
              if (firebase.currentUser?.email.toString() ==
                  usernameController.text) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
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
        //actions: const [PopupMenu()], //short term fix for odd page error
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 128 + 64, left: 8, right: 8, bottom: 8),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Input username';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Input password';
                      }
                      return null;
                    },
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                const LoginButton(),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegisterPage(
                                    title: 'Register page',
                                  )));
                        },
                        child: const Text("Register"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
