import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/countdown_event.dart';

final eventProvider = StateNotifierProvider<EventNotifier, List<CountdownEvent>>((ref) {
  return EventNotifier();
});

class EventNotifier extends StateNotifier<List<CountdownEvent>> {
  EventNotifier() : super([]) {
    _loadEvents();
  }

  static const String _storageKey = 'timesnap_events';

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final String? eventsJson = prefs.getString(_storageKey);
    if (eventsJson != null) {
      final List<dynamic> decoded = json.decode(eventsJson);
      state = decoded.map((e) => CountdownEvent.fromMap(e)).toList();
    }
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(state.map((e) => e.toMap()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  void addEvent(CountdownEvent event) {
    state = [event];
    _saveEvents();
  }

  void removeEvent(String id) {
    state = state.where((e) => e.id != id).toList();
    _saveEvents();
  }

  void togglePin(String id) {
    state = state.map((e) {
      if (e.id == id) {
        return e.copyWith(isPinned: !e.isPinned);
      }
      return e;
    }).toList();
    _saveEvents();
  }
}

final pinnedEventProvider = Provider<CountdownEvent?>((ref) {
  final events = ref.watch(eventProvider);
  if (events.isEmpty) return null;
  final pinned = events.where((e) => e.isPinned).toList();
  if (pinned.isNotEmpty) return pinned.first;
  return events.first;
});
