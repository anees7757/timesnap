import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'liquid_glass.dart';

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
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          layoutBuilder:
              (Widget? currentChild, List<Widget> previousChildren) {
            return Stack(
              alignment: Alignment.center,
              children: [
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          transitionBuilder:
              (Widget child, Animation<double> animation) {
            final isNew = child.key == ValueKey(formattedValue);

            return AnimatedBuilder(
              animation: animation,
              child: child,
              builder: (context, child) {
                double rotation = 0.0;
                if (isNew) {
                  rotation = (animation.value < 0.5)
                      ? math.pi / 2
                      : (1.0 - (animation.value - 0.5) * 2) *
                          (-math.pi / 2);
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
                    opacity:
                        (rotation.abs() >= math.pi / 2) ? 0.0 : 1.0,
                    child: child!,
                  ),
                );
              },
            );
          },
          child: LiquidGlass(
            key: ValueKey(formattedValue),
            borderRadius: 16,
            blurSigma: 30,
            tintOpacity: 0.06,
            borderOpacity: 0.14,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  formattedValue,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: -1,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                // Center divider line (classic flip-clock)
                Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1,
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.25),
                letterSpacing: 4,
                fontSize: 10,
                fontWeight: FontWeight.w800,
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
