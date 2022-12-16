import 'package:flutter_riverpod/flutter_riverpod.dart';

final chipCounterProvider = StateNotifierProvider((ref) {
  return Counter();
});

class Counter extends StateNotifier<int> {
  Counter() : super(1);

  void set(int value) {
    state = value;
  }
}

final chipCounterDirectionProvider = StateProvider<bool>((ref) => false);