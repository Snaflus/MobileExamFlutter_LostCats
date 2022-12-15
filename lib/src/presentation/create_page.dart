import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/popup_menu.dart';

import '../data/cat_repository.dart';
import '../data/firebase_providers.dart';
import '../domain/cat.dart';

final nameController = TextEditingController();
final descController = TextEditingController();
final placeController = TextEditingController();
final rewardController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class CreatePage extends StatefulWidget {
  const CreatePage({super.key, required this.title});

  final String title;

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class SubmitButton extends ConsumerWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var firebase = ref.read(firebaseAuthProvider); //used to pass functions
    var cats = ref.read(catRepositoryProvider); //used to pass functions

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: SizedBox(
        width: 200,
        height: 42,
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                Cat cat = Cat.createWithoutPicture(
                    nameController.text,
                    descController.text,
                    placeController.text,
                    int.parse(rewardController.text),
                    firebase.currentUser!.email!);
                debugPrint("DEBUG $cat");
                final operation = await cats.postCat(cat);
              } on Exception catch (e) {
                debugPrint(e.toString());
              }
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Add cat',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          //actions: const [PopupMenu()], //logging out on create cat page produces unintended behaviour
        ),
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
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
                          return "Input cat's name";
                        }
                        return null;
                      },
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Cat's name",
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Input cat's description";
                        }
                        return null;
                      },
                      controller: descController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Cat's description",
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Input cat's place";
                        }
                        return null;
                      },
                      controller: placeController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Cat's place",
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Input cat's reward";
                        }
                        return null;
                      },
                      controller: rewardController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Cat's reward",
                      ),
                    ),
                  ),
                  const SubmitButton(),
                ],
              ),
            ),
          ),
        ));
  }
}
