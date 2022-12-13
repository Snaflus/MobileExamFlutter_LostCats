import 'package:mobile_exam_flutter_lostcats/src/domain/cat.dart';
import 'package:mobile_exam_flutter_lostcats/src/data/cat_repository.dart';

class CatViewModel {
  final repository = CatRepository();
  List<Cat> cats = List.empty();

  void reload() async {
    cats = await repository.getCats();
  }

  Future<Cat?> getCat(int id) async {
    return await repository.getCat(id);
  }

  Future<List<Cat>> getCats() async {
    return await repository.getCats();
  }

  Future<Cat> postCat(Cat cat) async {
    return repository.postCat(cat);
  }
}