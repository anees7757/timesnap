import 'package:flutter/material.dart';
import 'flip_digit.dart';

class FlipClock extends StatelessWidget {
  final Duration duration;

  const FlipClock({
    super.key,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {

    final days = duration.inDays.clamp(0, 99);
    final hours = duration.inHours.remainder(24).clamp(0, 23);
    final minutes = duration.inMinutes.remainder(60).clamp(0, 59);
    final seconds = duration.inSeconds.remainder(60).clamp(0, 59);

    return Wrap(
      spacing: 32,
      runSpacing: 32,
      alignment: WrapAlignment.center,
      children: [
        FlipDigit(value: days, label: 'Days'),
        FlipDigit(value: hours, label: 'Hours'),
        FlipDigit(value: minutes, label: 'Minutes'),
        FlipDigit(value: seconds, label: 'Seconds'),
      ],
    );
  }
}
