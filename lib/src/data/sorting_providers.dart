import 'package:flutter_riverpod/flutter_riverpod.dart';

final chipCounterProvider = StateNotifierProvider((ref) {
  return Counter();
});

class Counter extends StateNotifier<int> {
  Counter() : super(1);

  void set(int value) {
    state = value;
  }

  void increment() => state++; //unused, added for demonstration in report
}

final chipCounterDirectionProvider = StateProvider<bool>((ref) => false);