import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/popup_menu.dart';

import '../data/firebase_providers.dart';
import '../domain/cat.dart';

final usernameController = TextEditingController();
final passwordController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class CreatePage extends StatefulWidget {
  const CreatePage({super.key, required this.title});

  final String title;

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
          ),
        ));
  }
}
