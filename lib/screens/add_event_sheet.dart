import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_theme.dart';
import '../models/countdown_event.dart';
import '../providers/event_provider.dart';

class AddEventSheet extends ConsumerStatefulWidget {
  final CountdownEvent? existingEvent;

  const AddEventSheet({super.key, this.existingEvent});

  @override
  ConsumerState<AddEventSheet> createState() => _AddEventSheetState();
}

class _AddEventSheetState extends ConsumerState<AddEventSheet>
    with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 0, minute: 0);
  String _selectedEmoji = '⏳';
  String? _errorText;

  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;

  bool get _isEditMode => widget.existingEvent != null;

  @override
  void initState() {
    super.initState();

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn));

    if (_isEditMode) {
      final e = widget.existingEvent!;
      _titleController.text = e.title;
      _selectedDate = DateTime(
        e.targetDate.year,
        e.targetDate.month,
        e.targetDate.day,
      );
      _selectedTime = TimeOfDay(
        hour: e.targetDate.hour,
        minute: e.targetDate.minute,
      );
      _selectedEmoji = e.emoji;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  void _saveEvent() {
    if (_titleController.text.trim().isEmpty) {
      _showError('Please enter an event title');
      return;
    }

    final finalDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (finalDateTime.isBefore(DateTime.now())) {
      _showError('Please select a future date and time');
      return;
    }

    if (_isEditMode) {
      final updated = widget.existingEvent!.copyWith(
        title: _titleController.text.trim(),
        targetDate: finalDateTime,
        emoji: _selectedEmoji,
      );
      ref.read(eventProvider.notifier).updateEvent(updated);
    } else {
      final event = CountdownEvent(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        targetDate: finalDateTime,
        emoji: _selectedEmoji,
      );
      ref.read(eventProvider.notifier).addEvent(event);
    }
    Navigator.pop(context);
  }

  void _showError(String msg) {
    setState(() => _errorText = msg);
    _shakeCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: cs.onSurface.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child:
          Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: cs.onSurface.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    _isEditMode ? 'EDIT COUNTDOWN' : 'NEW COUNTDOWN',
                    style: tt.labelSmall?.copyWith(
                      letterSpacing: 4,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: cs.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Title input
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Event Title',
                      hintText: 'e.g. My Birthday',
                    ),
                    autofocus: true,
                    onChanged: (_) {
                      if (_errorText != null) {
                        setState(() => _errorText = null);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date & Time pickers in liquid glass cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildPickerCard(
                          label: 'Date',
                          value: DateFormat(
                            'MMM d, yyyy',
                          ).format(_selectedDate),
                          icon: Icons.calendar_today_rounded,
                          onTap: _pickDate,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPickerCard(
                          label: 'Time',
                          value: _selectedTime.format(context),
                          icon: Icons.access_time_rounded,
                          onTap: _pickTime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Error
                  if (_errorText != null)
                    AnimatedBuilder(
                      animation: _shakeAnim,
                      builder: (context, child) {
                        final dx =
                            _shakeAnim.value *
                            8 *
                            ((_shakeAnim.value * 10).truncate().isOdd ? 1 : -1);
                        return Transform.translate(
                          offset: Offset(dx, 0),
                          child: child,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _errorText!,
                          style: TextStyle(
                            color: cs.error,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  // Save button — liquid glass with accent tint
                  GestureDetector(
                    onTap: _saveEvent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          _isEditMode ? 'UPDATE COUNTDOWN' : 'START COUNTDOWN',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            fontSize: 14,
                            color: cs.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.05, duration: 300.ms, curve: Curves.easeOut),
    );
  }

  Widget _buildPickerCard({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: cs.onSurface.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: cs.primary.withValues(alpha: 0.7)),
            const SizedBox(height: 8),
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 2,
                fontSize: 9,
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: cs.onSurface.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _errorText = null;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _errorText = null;
      });
    }
  }
}
