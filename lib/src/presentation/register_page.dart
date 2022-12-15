import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/popup_menu.dart';

import '../data/firebase_providers.dart';
import '../domain/cat.dart';

final usernameController = TextEditingController();
final passwordController = TextEditingController();
final passwordRepeatController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.title});

  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class RegisterButton extends ConsumerWidget {
  const RegisterButton({super.key});

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
                final credential =
                    await firebase.createUserWithEmailAndPassword(
                        email: usernameController.text,
                        password: passwordController.text);
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'email-already-in-use':
                    {
                      debugPrint('Provided email already in use');
                    }

                    break;
                  case 'invalid-email':
                    {
                      debugPrint('Provided email not valid');
                    }

                    break;
                  case 'weak-password':
                    {
                      debugPrint('Provided password too weak');
                    }
                    break;

                  default:
                    {
                      debugPrint('Unexpected FirebaseAuthException in register');
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
            'Register',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        //actions: const [PopupMenu()], //short term fix for odd page error
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Input password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords must match';
                      }
                      return null;
                    },
                    controller: passwordRepeatController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Repeat password',
                    ),
                  ),
                ),
                const RegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
