import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projekt_todo_tojson/models/app_state.dart';

/// An abstract interface definition for managing the application state lifecycle
/// and handling core user actions.
///
/// Implements Riverpod's [Notifier] to expose an immutable [AppState] to the UI.
abstract class AppStateNotifierInterface extends Notifier<AppState> {
  
  /// Asynchronously loads the initial application state from persistent storage.
  Future<void> loadState();

  /// Persists the current state configuration to the storage layer.
  Future<void> saveState();

  /// Creates and appends a new todo item with the given [text].
  ///
  /// Blanks or whitespace-only inputs should be ignored.
  void addTodo(String text);

  /// Toggles the completion status ([Todo.isCompleted]) of a specific item by its [id].
  void toggleTodo(String id);

  /// Toggles the selection status of a specific item by its [id] 
  /// for bulk actions.
  void toggleSelection(String id);

  /// Clears all currently selected item IDs from the state.
  void clearSelection();

  /// Asynchronously deletes all items whose IDs are present in the selection set
  /// from both local state and persistent storage.
  Future<void> deleteSelectedTodos();

  /// Switches the user interface theme between light and dark modes.
  void toggleDarkMode();

  /// Toggles the global preference for displaying a confirmation dialog 
  /// prior to data deletion.
  void toggleDeletionConfirmation();
}