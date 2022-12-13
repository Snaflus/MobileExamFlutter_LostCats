import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:mobile_exam_flutter_lostcats/src/domain/cat.dart';
const url = "https://anbo-restlostcats.azurewebsites.net/api/Cats";

class CatRepository {
  List<Cat> cats = List.empty(growable: true);

  Future<Cat?> getCat(int id) async {
    final response = await http.get(Uri.parse("$url/$id"));

    if (response.statusCode == 200) { //200 OK
      return Cat.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to get cat");
    }
  }

  Future<List<Cat>> getCats() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) { //200 OK
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Cat>((json) => Cat.fromJson(json)).toList(); //consider compute
      //https://docs.flutter.dev/cookbook/networking/background-parsing#convert-the-response-into-a-list-of-photos
    } else {
      throw Exception("Failed to get cats");
    }
  }

  Future<Cat> postCat(Cat cat) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(cat),
    );

    if (response.statusCode == 201) { //201 CREATED
      return Cat.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }
}