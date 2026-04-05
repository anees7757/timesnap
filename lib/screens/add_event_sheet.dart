import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/countdown_event.dart';
import '../providers/event_provider.dart';

class AddEventSheet extends ConsumerStatefulWidget {
  const AddEventSheet({super.key});

  @override
  ConsumerState<AddEventSheet> createState() => _AddEventSheetState();
}

class _AddEventSheetState extends ConsumerState<AddEventSheet> {
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 0, minute: 0);
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final event = ref.read(pinnedEventProvider);
    if (event != null) {
      _titleController.text = event.title;
      _selectedDate = DateTime(event.targetDate.year, event.targetDate.month, event.targetDate.day);
      _selectedTime = TimeOfDay(hour: event.targetDate.hour, minute: event.targetDate.minute);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveEvent() {
    if (_titleController.text.isEmpty) return;

    final finalDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (finalDateTime.isBefore(DateTime.now())) {
      setState(() {
        _errorText = 'Please select a future date and time';
      });
      return;
    }

    final event = CountdownEvent(
      id: const Uuid().v4(),
      title: _titleController.text,
      targetDate: finalDateTime,
    );

    ref.read(eventProvider.notifier).addEvent(event);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomPadding),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            ref.read(pinnedEventProvider) == null ? 'Set Countdown' : 'Update Countdown',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Event Title',
              hintText: 'e.g. My Birthday',
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildPickerCard(
                  label: 'Date',
                  value: DateFormat('MMM d, yyyy').format(_selectedDate),
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
          const SizedBox(height: 32),
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                _errorText!,
                style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ElevatedButton(
            onPressed: _saveEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              ref.read(pinnedEventProvider) == null ? 'Start Countdown' : 'Update Countdown',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerCard({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
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
