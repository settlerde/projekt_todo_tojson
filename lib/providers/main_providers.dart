// Derived providers
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:projekt_todo_tojson/models/app_state.dart';
import 'package:projekt_todo_tojson/models/todo.dart';
import 'package:projekt_todo_tojson/providers/app_state_notifier_interface.dart';
import 'package:projekt_todo_tojson/providers/database_notifier.dart';
import 'package:projekt_todo_tojson/providers/json_state_notifier.dart';

// Main providers
final todosProvider = Provider<List<Todo>>((ref) {
  return ref.watch(isSqLiteProvider) ? ref.watch(sqliteStateProvider).todos : ref.watch(jsonStateProvider).todos;
});

final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).isDarkMode;
});

final selectedTodosProvider = Provider<Set<String>>((ref) {
  return ref.watch(appStateProvider).selectedTodoIds;
});

final hasSelectedTodosProvider = Provider<bool>((ref) {
  return ref.watch(selectedTodosProvider).isNotEmpty;
});

final asksForConfirmationProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).asksForDeletionConfirmation;
});

final appStateProvider = Provider<AppState>((ref) {
  return ref.watch(isSqLiteProvider) ? ref.watch(sqliteStateProvider) : ref.watch(jsonStateProvider);
});

final appStateNotifierProvider = Provider<AppStateNotifierInterface>((ref) {
  return ref.watch(isSqLiteProvider) ? ref.watch(sqliteStateProvider.notifier) : ref.watch(jsonStateProvider.notifier);
});

final isSqLiteProvider = StateProvider<bool>((ref) => true); // Placeholder for future SQLite toggle implementation

/// This provider allows widgets to access and modify the app state through the DatabaseNotifier.
// Notifier listens to changes in AppState and notifies any widgets that are subscribed to it
final jsonStateProvider = NotifierProvider<AppStateNotifierInterface, AppState>(
  () => JsonStateNotifier(), // JSON implementation
);

final sqliteStateProvider = NotifierProvider<AppStateNotifierInterface, AppState>(
  () => DatabaseNotifier(), // SQLite implementation
);
