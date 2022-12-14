import 'package:flutter/material.dart';
import 'package:mobile_exam_flutter_lostcats/src/data/cat_repository.dart';
import 'package:mobile_exam_flutter_lostcats/src/domain/cat_view_model.dart';

import '../domain/Cat.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.title});

  final String title;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final viewModel = CatViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: viewModel.getCats(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.toString());
                } else {
                  return Text("Error");
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.reload();
          //print(viewModel.cats.toString());
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
