import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});
