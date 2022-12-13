import 'package:flutter/material.dart';
import 'package:mobile_exam_flutter_lostcats/src/presentation/list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark
      ),
      themeMode: ThemeMode.dark, //dark, light, system
      debugShowCheckedModeBanner: false,
      home: const ListPage(title: 'Lost Cats List'),
    );
  }
}