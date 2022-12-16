import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/details_page.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/popup_menu.dart';

import '../data/cat_providers.dart';
import '../data/cat_repository.dart';
import '../data/firebase_providers.dart';
import '../data/sorting_providers.dart';
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
    int? sortingValue = int.parse(ref.watch(chipCounterProvider).toString());
    bool sortingDirection = ref.watch(chipCounterDirectionProvider);

    return cats.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (cats) {
        catList = cats.map((e) => e).toList();
        switch (sortingValue) {
          case 1:
            sortingDirection
                ? catList.sort((a, b) => b.name.compareTo(a.name))
                : catList.sort((a, b) => a.name.compareTo(b.name));
            break;
          case 2:
            sortingDirection
                ? catList.sort((a, b) => b.place.compareTo(a.place))
                : catList.sort((a, b) => a.place.compareTo(b.place));
            break;
          case 3:
            sortingDirection
                ? catList.sort((a, b) => b.reward.compareTo(a.reward))
                : catList.sort((a, b) => a.reward.compareTo(b.reward));
            break;
          case 4:
            sortingDirection
                ? catList.sort((a, b) => b.date.compareTo(a.date))
                : catList.sort((a, b) => a.date.compareTo(b.date));
            break;
          case 5:
            sortingDirection
                ? catList.sort((a, b) => b.id.compareTo(a.id))
                : catList.sort((a, b) => a.id.compareTo(b.id));
            break;
          default:
            debugPrint("unhandled cat sorting switch");
        }
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

class SortingOptions extends ConsumerWidget {
  const SortingOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    int? value = int.parse(ref.watch(chipCounterProvider).toString());
    //bool direction = ref.watch(chipCounterDirectionProvider);

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              selected: value == 1,
              onSelected: (bool selected) {
                if (value == 1) {
                  ref.read(chipCounterDirectionProvider.notifier).state =
                      !ref.read(chipCounterDirectionProvider.notifier).state;
                } else {
                  ref.read(chipCounterDirectionProvider.notifier).state = false;
                  ref.read(chipCounterProvider.notifier).set(1);
                }
              },
              elevation: 20,
              padding:
                  const EdgeInsets.only(left: 8, top: 4, right: 4, bottom: 4),
              selectedColor: isDarkMode
                  ? ThemeData.dark().colorScheme.inversePrimary
                  : ThemeData.light().colorScheme.inversePrimary,
              backgroundColor: isDarkMode
                  ? ThemeData.dark().colorScheme.secondary
                  : ThemeData.light().colorScheme.secondary,
              shadowColor: Colors.black,
              avatar: Icon(Icons.sort_by_alpha,
                  color: isDarkMode
                      ? ThemeData.dark().primaryColor
                      : ThemeData.light().colorScheme.onSecondary),
              label: Text(
                "Name",
                style: TextStyle(
                    color: isDarkMode
                        ? ThemeData.dark().primaryColor
                        : ThemeData.light().colorScheme.onSecondary),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              selected: value == 2,
              onSelected: (bool selected) {
                if (value == 2) {
                  ref.read(chipCounterDirectionProvider.notifier).state =
                  !ref.read(chipCounterDirectionProvider.notifier).state;
                } else {
                  ref.read(chipCounterDirectionProvider.notifier).state = false;
                  ref.read(chipCounterProvider.notifier).set(2);
                }
              },
              elevation: 20,
              padding:
                  const EdgeInsets.only(left: 8, top: 4, right: 4, bottom: 4),
              selectedColor: isDarkMode
                  ? ThemeData.dark().colorScheme.inversePrimary
                  : ThemeData.light().colorScheme.inversePrimary,
              backgroundColor: isDarkMode
                  ? ThemeData.dark().colorScheme.secondary
                  : ThemeData.light().colorScheme.secondary,
              shadowColor: Colors.black,
              avatar: Icon(Icons.sort_by_alpha,
                  color: isDarkMode
                      ? ThemeData.dark().primaryColor
                      : ThemeData.light().colorScheme.onSecondary),
              label: Text(
                "Place",
                style: TextStyle(
                    color: isDarkMode
                        ? ThemeData.dark().primaryColor
                        : ThemeData.light().colorScheme.onSecondary),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              selected: value == 3,
              onSelected: (bool selected) {
                if (value == 3) {
                  ref.read(chipCounterDirectionProvider.notifier).state =
                  !ref.read(chipCounterDirectionProvider.notifier).state;
                } else {
                  ref.read(chipCounterDirectionProvider.notifier).state = false;
                  ref.read(chipCounterProvider.notifier).set(3);
                }
              },
              elevation: 20,
              padding:
                  const EdgeInsets.only(left: 8, top: 4, right: 4, bottom: 4),
              selectedColor: isDarkMode
                  ? ThemeData.dark().colorScheme.inversePrimary
                  : ThemeData.light().colorScheme.inversePrimary,
              backgroundColor: isDarkMode
                  ? ThemeData.dark().colorScheme.secondary
                  : ThemeData.light().colorScheme.secondary,
              shadowColor: Colors.black,
              avatar: Icon(Icons.sort_by_alpha,
                  color: isDarkMode
                      ? ThemeData.dark().primaryColor
                      : ThemeData.light().colorScheme.onSecondary),
              label: Text(
                "Reward",
                style: TextStyle(
                    color: isDarkMode
                        ? ThemeData.dark().primaryColor
                        : ThemeData.light().colorScheme.onSecondary),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              selected: value == 4,
              onSelected: (bool selected) {
                if (value == 4) {
                  ref.read(chipCounterDirectionProvider.notifier).state =
                  !ref.read(chipCounterDirectionProvider.notifier).state;
                } else {
                  ref.read(chipCounterDirectionProvider.notifier).state = false;
                  ref.read(chipCounterProvider.notifier).set(4);
                }
              },
              elevation: 20,
              padding:
                  const EdgeInsets.only(left: 8, top: 4, right: 4, bottom: 4),
              selectedColor: isDarkMode
                  ? ThemeData.dark().colorScheme.inversePrimary
                  : ThemeData.light().colorScheme.inversePrimary,
              backgroundColor: isDarkMode
                  ? ThemeData.dark().colorScheme.secondary
                  : ThemeData.light().colorScheme.secondary,
              shadowColor: Colors.black,
              avatar: Icon(Icons.sort_by_alpha,
                  color: isDarkMode
                      ? ThemeData.dark().primaryColor
                      : ThemeData.light().colorScheme.onSecondary),
              label: Text(
                "Date",
                style: TextStyle(
                    color: isDarkMode
                        ? ThemeData.dark().primaryColor
                        : ThemeData.light().colorScheme.onSecondary),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              selected: value == 5,
              onSelected: (bool selected) {
                if (value == 5) {
                  ref.read(chipCounterDirectionProvider.notifier).state =
                  !ref.read(chipCounterDirectionProvider.notifier).state;
                } else {
                  ref.read(chipCounterDirectionProvider.notifier).state = false;
                  ref.read(chipCounterProvider.notifier).set(5);
                }
              },
              elevation: 20,
              padding:
                  const EdgeInsets.only(left: 8, top: 4, right: 4, bottom: 4),
              selectedColor: isDarkMode
                  ? ThemeData.dark().colorScheme.inversePrimary
                  : ThemeData.light().colorScheme.inversePrimary,
              backgroundColor: isDarkMode
                  ? ThemeData.dark().colorScheme.secondary
                  : ThemeData.light().colorScheme.secondary,
              shadowColor: Colors.black,
              avatar: Icon(Icons.sort_by_alpha,
                  color: isDarkMode
                      ? ThemeData.dark().primaryColor
                      : ThemeData.light().colorScheme.onSecondary),
              label: Text(
                "ID",
                style: TextStyle(
                    color: isDarkMode
                        ? ThemeData.dark().primaryColor
                        : ThemeData.light().colorScheme.onSecondary),
              ),
            ),
          ),
        ],
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              SortingOptions(),
              CatList(),
            ],
          ),
        ),
      ),
      floatingActionButton: const AddCatFAB(),
    );
  }
}
