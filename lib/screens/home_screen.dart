import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/event_provider.dart';
import '../providers/timer_provider.dart';
import '../widgets/flip_clock.dart';
import 'add_event_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinnedEvent = ref.watch(pinnedEventProvider);
    ref.watch(timerProvider);

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (pinnedEvent != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: cs.primary.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'TIMESNAP',
                        style: tt.labelSmall?.copyWith(
                          letterSpacing: 3,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                          color: cs.primary.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      pinnedEvent.title.toUpperCase(),
                      style: GoogleFonts.bebasNeue(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 8,
                        color: cs.onSurface,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 56),

                    FlipClock(
                      duration: pinnedEvent.hasPassed
                          ? Duration.zero
                          : pinnedEvent.timeLeft,
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          pinnedEvent.hasPassed ? 'TIME PASSED' : 'REMAINING',
                          style: tt.labelSmall?.copyWith(
                            letterSpacing: 4,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: pinnedEvent.hasPassed
                                ? cs.error.withValues(alpha: 0.6)
                                : cs.primary.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: cs.onSurface.withValues(alpha: 0.25),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat(
                            'EEEE, MMMM d, yyyy  •  HH:mm',
                          ).format(pinnedEvent.targetDate).toUpperCase(),
                          style: tt.labelSmall?.copyWith(
                            letterSpacing: 2.5,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface.withValues(alpha: 0.35),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    _buildEmptyState(context),
                  ],
                ],
              ),
            ),
          ),

          Positioned(
            right: 24,
            bottom: 28,
            child: IconButton(
              onPressed: () => _showAddEventSheet(context),
              icon: Icon(
                pinnedEvent == null ? Icons.add_rounded : Icons.edit_rounded,
                size: 28, // slight bump to make icon button visible
                color: cs.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: cs.onSurface.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.hourglass_empty_rounded,
              size: 32,
              color: cs.onSurface.withValues(alpha: 0.18),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'NO COUNTDOWN SET',
            style: tt.labelLarge?.copyWith(
              letterSpacing: 5,
              fontWeight: FontWeight.w900,
              color: cs.onSurface.withValues(alpha: 0.2),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Set a target date and start\nyour countdown.',
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.25),
              height: 1.6,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          OutlinedButton.icon(
            onPressed: () => _showAddEventSheet(context),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('SET TIMER'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: tt.labelMedium?.copyWith(
                letterSpacing: 3,
                fontWeight: FontWeight.w800,
              ),
              side: BorderSide(
                color: cs.primary.withValues(alpha: 0.3),
                width: 1,
              ),
              foregroundColor: cs.primary.withValues(alpha: 0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEventSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddEventSheet(),
    );
  }
}
