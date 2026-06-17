import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projekt_todo_tojson/models/app_state.dart';

abstract class AppStateNotifierInterface extends Notifier<AppState> {
  Future<void> loadState();
  Future<void> saveState();
  void addTodo(String text);
  void toggleTodo(String id);
  void toggleSelection(String id);
  void clearSelection();
  Future<void> deleteSelectedTodos();
  void toggleDarkMode();
  void toggleDeletionConfirmation();
}
