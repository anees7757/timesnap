import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'flip_digit.dart';

class FlipClock extends StatelessWidget {
  final Duration duration;

  const FlipClock({
    super.key,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final days = duration.inDays.clamp(0, 99);
    final hours = duration.inHours.remainder(24).clamp(0, 23);
    final minutes = duration.inMinutes.remainder(60).clamp(0, 59);
    final seconds = duration.inSeconds.remainder(60).clamp(0, 59);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlipDigit(value: days, label: 'Days'),
        _buildColon(cs),
        FlipDigit(value: hours, label: 'Hours'),
        _buildColon(cs),
        FlipDigit(value: minutes, label: 'Min'),
        _buildColon(cs),
        FlipDigit(value: seconds, label: 'Sec'),
      ],
    )
        .animate()
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .slideY(begin: 0.08, end: 0, duration: 600.ms, curve: Curves.easeOut);
  }

  Widget _buildColon(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 136, // match digit card height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ColonDot(color: cs.primary.withValues(alpha: 0.35)),
            const SizedBox(height: 14),
            _ColonDot(color: cs.primary.withValues(alpha: 0.35)),
          ],
        ),
      ),
    );
  }
}

/// A single colon dot that pulses.
class _ColonDot extends StatefulWidget {
  final Color color;
  const _ColonDot({required this.color});

  @override
  State<_ColonDot> createState() => _ColonDotState();
}

class _ColonDotState extends State<_ColonDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _opacity = Tween(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.4),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
