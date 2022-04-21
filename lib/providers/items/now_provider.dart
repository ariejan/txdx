import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final timeProvider = StateNotifierProvider<TimeNotifier, DateTime>((ref) => TimeNotifier());

class TimeNotifier extends StateNotifier<DateTime> {
  TimeNotifier() : super(DateTime.now()) {
    _tickerSubscription = _ticker.tick().listen((datetime) => state = datetime);
  }

  final _ticker = Ticker();
  StreamSubscription<DateTime>? _tickerSubscription;

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }
}

class Ticker {
  Stream<DateTime> tick() {
    return Stream.periodic(
      const Duration(seconds: 1),
      (x) => DateTime.now(),
    );
  }
}