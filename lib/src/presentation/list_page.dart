import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/details_page.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/popup_menu.dart';

import '../data/cat_providers.dart';
import '../data/firebase_providers.dart';
import '../domain/cat.dart';
import 'create_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.title});
  final String title;

  @override
  State<ListPage> createState() => _ListPageState();
}

class CatList extends ConsumerWidget {
  const CatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cats = ref.watch(catsDataProvider);

    return cats.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (cats) {
        List<Cat> catList = cats.map((e) => e).toList();
        return Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              return await ref.refresh(catsDataProvider);
            },
            child: ListView.builder(
              itemCount: catList.length,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          DetailsPage(title: "", cat: catList[index]))),
                  child: Card(
                    child: ListTile(
                      title: Text(catList[index].name),
                      subtitle: Text(catList[index].place),
                      trailing: const CircleAvatar(
                        backgroundImage: AssetImage('images/cat.png'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class AddCatFAB extends ConsumerWidget {
  const AddCatFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authStateChangesProvider); //listens and rebuilds widget
    var firebase = ref.read(firebaseAuthProvider); //used to pass functions

    return FloatingActionButton(
      onPressed: () {
        if (firebase.currentUser != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CreatePage(
                    title: 'Add a cat',
                  )));
        } else {
          const snackBar = SnackBar(
            content: Text("Add cat only available for logged in users"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: const [PopupMenu()],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              CatList(),
            ],
          ),
        ),
      ),
      floatingActionButton: const AddCatFAB(),
    );
  }
}
