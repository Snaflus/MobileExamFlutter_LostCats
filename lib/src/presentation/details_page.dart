import 'package:flutter/material.dart';

import '../domain/cat.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key, required this.title, required this.cat}) : super(key: key);
  final String title;
  final Cat cat;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('images/cat.png'),),
              Text(cat.id.toString()),
              Text(cat.name),
              Text(cat.description),
              Text(cat.place),
              Text(cat.reward.toString()),
              Text(cat.userId),
              Text(cat.humanDate()),
              Container(
                child: cat.pictureUrl != null ? Text(cat.pictureUrl!) : null,
              )
            ],
          ),
        ),
      )
    );
  }
}