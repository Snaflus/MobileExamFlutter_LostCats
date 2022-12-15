import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_exam_flutter_lostcats/src/data/cat_providers.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/popup_menu.dart';

import '../data/cat_repository.dart';
import '../data/firebase_providers.dart';
import '../domain/cat.dart';

class DeleteButton extends ConsumerWidget {
  const DeleteButton({Key? key, required this.cat}) : super(key: key);
  final Cat cat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authStateChangesProvider); //listens and rebuilds widget
    var firebase = ref.read(firebaseAuthProvider); //used to pass functions
    var cats = ref.read(catRepositoryProvider); //used to pass functions

    var button = Padding(
      padding: const EdgeInsets.only(top: 64),
      child: ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Confirm deletion'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [Text("Cat: '${cat.name}' at '${cat.place}'")],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    try {
                      final operation = await cats.deleteCat(cat.id);
                    } on Exception catch (e) {
                      debugPrint(e.toString());
                    }
                    Navigator.popUntil(context, (route) => route.isFirst);
                    ref.invalidate(catsDataProvider);
                  },
                  child: const Text("Confirm")),
              TextButton(onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text("Cancel"))
            ],
          ),
        ),
        child: const Text(
          'Delete cat',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );

    if (cat.userId == firebase.currentUser?.email) {
      return button;
    } else {
      return Container();
    }
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key, required this.title, required this.cat})
      : super(key: key);
  final String title;
  final Cat cat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: const [PopupMenu()],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('images/cat.png'),
                ),
                Text(cat.id.toString()),
                Text(cat.name),
                Text(cat.description),
                Text(cat.place),
                Text(cat.reward.toString()),
                Text(cat.userId),
                Text(cat.humanDate()),
                Container(
                  child: cat.pictureUrl != null ? Text(cat.pictureUrl!) : null,
                ),
                DeleteButton(cat: cat),
              ],
            ),
          ),
        ));
  }
}
