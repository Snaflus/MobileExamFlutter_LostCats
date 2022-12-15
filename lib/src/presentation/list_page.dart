import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/details_page.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/popup_menu.dart';

import '../data/cat_providers.dart';
import '../data/cat_repository.dart';
import '../data/firebase_providers.dart';
import '../domain/cat.dart';
import 'create_page.dart';

List<Cat> catList = List.empty();
//late List<Cat> catList;

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
        catList = cats.map((e) => e).toList();
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
                      builder: (context) => DetailsPage(
                          title: "Cat details", cat: catList[index]))),
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

class CatSearchDelegate extends SearchDelegate {
  //clear search text when clicked
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  //create back arrow
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  //show query after search
  @override
  Widget buildResults(BuildContext context) {
    List<Cat> matchQuery = [];
    for (var data in catList) {
      if (data.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(data);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  DetailsPage(title: "Cat details", cat: result))),
          child: ListTile(
            title: Text(result.name),
            subtitle: Text(result.place),
            trailing: const CircleAvatar(
            backgroundImage: AssetImage('images/cat.png'),
          ),
          ),
        );
      },
    );
  }

  //show query while typing
  @override
  Widget buildSuggestions(BuildContext context) {
    List<Cat> matchQuery = [];
    for (var data in catList) {
      if (data.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(data);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  DetailsPage(title: "Cat details", cat: result))),
          child: ListTile(
            title: Text(result.name),
            subtitle: Text(result.place),
            trailing: const CircleAvatar(
              backgroundImage: AssetImage('images/cat.png'),
            ),
          ),
        );
      },
    );
  }
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CatSearchDelegate());
              },
              icon: const Icon(Icons.search)),
          const PopupMenu()
        ],
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
