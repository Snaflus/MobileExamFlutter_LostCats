import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_exam_flutter_lostcats/src/data/cat_repository.dart';

import '../domain/cat.dart';

final catsDataProvider = FutureProvider.autoDispose<List<Cat>>((ref) async {
    return ref.watch(catRepositoryProvider).getCats();
});