import 'dart:math' as math;
import 'package:flutter/material.dart';


class FlipDigit extends StatelessWidget {
  final int value;
  final String label;

  const FlipDigit({super.key, required this.value, this.label = ''});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formattedValue = _formatValue(value);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
            return Stack(
              alignment: Alignment.center,
              children: [
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          transitionBuilder: (Widget child, Animation<double> animation) {
            final isNew = child.key == ValueKey(formattedValue);

            return AnimatedBuilder(
              animation: animation,
              child: child,
              builder: (context, child) {
                double rotation = 0.0;
                if (isNew) {

                  rotation = (animation.value < 0.5)
                      ? math.pi / 2
                      : (1.0 - (animation.value - 0.5) * 2) * (-math.pi / 2);
                } else {

                  rotation = (animation.value > 0.5)
                      ? (1.0 - animation.value) * 2 * (math.pi / 2)
                      : math.pi / 2;
                }

                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(rotation),
                  alignment: Alignment.center,
                  child: Opacity(

                    opacity: (rotation.abs() >= math.pi / 2) ? 0.0 : 1.0,
                    child: child!,
                  ),
                );
              },
            );
          },
          child: Container(
            key: ValueKey(formattedValue),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              formattedValue,
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 80,
                fontWeight: FontWeight.w900,
                height: 1.0,
                letterSpacing: -1,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.3),
                letterSpacing: 4,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
      ],
    );
  }

  String _formatValue(int val) {
    return val.toString().padLeft(2, '0');
  }
}
