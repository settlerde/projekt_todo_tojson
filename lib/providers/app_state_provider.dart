import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projekt_todo_tojson/models/app_state.dart';
import 'package:projekt_todo_tojson/models/todo.dart';
import 'package:projekt_todo_tojson/services/storage_service.dart';

/// this class is responsible for managing the state of the app.
/// Its primary task is to respond to user actions (such as button presses or text input),
/// modify data within AppState, and automatically save it to the device.

class AppStateNotifier extends Notifier<AppState> {
  final _storageService = StorageService();

  @override
  AppState build() {
    //entry point for notifier, called when provider is first accessed.
    Future.microtask(
      () => loadState(),
    ); // a way to trigger an asynchronous load at startup without blocking the UI.
    return AppState();
  }

  // Load state from storage
  Future<void> loadState() async {
    try {
      final appState = await _storageService.loadAppState();
      if (appState != null) {
        state = appState;
      }
    } catch (e) {
      // Handle error or use default state
      print('Error loading state: $e');
    }
  }

  // Save state to storage
  Future<void> saveState() async {
    try {
      await _storageService.saveAppState(state);
    } catch (e) {
      print('Error saving state: $e');
    }
  }

  // Add a new todo
  void addTodo(String text) {
    if (text.trim().isEmpty) return;

    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
    );

    state = state.copyWith(todos: [...state.todos, newTodo]);

    saveState();
  }

  // Toggle todo completion status
  void toggleTodo(String id) {
    state = state.copyWith(
      todos: state.todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(isCompleted: !todo.isCompleted);
        }
        return todo;
      }).toList(),
    );

    saveState();
  }

  // Toggle todo selection
  void toggleSelection(String id) {
    final selectedIds = Set<String>.from(state.selectedTodoIds);
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }

    state = state.copyWith(selectedTodoIds: selectedIds);
  }

  // Clear all selections
  void clearSelection() {
    state = state.copyWith(selectedTodoIds: {});
  }

  // Delete selected todos
  Future<void> deleteSelectedTodos() async {
    if (state.selectedTodoIds.isEmpty) return;

    final remainingTodos = state.todos
        .where((todo) => !state.selectedTodoIds.contains(todo.id))
        .toList();

    state = state.copyWith(todos: remainingTodos, selectedTodoIds: {});

    saveState();
  }

  // Toggle dark mode
  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
    saveState();
  }

  // Toggle deletion confirmation
  void toggleDeletionConfirmation() {
    state = state.copyWith(
      asksForDeletionConfirmation: !state.asksForDeletionConfirmation,
    );
    saveState();
  }
}

/// This provider allows widgets to access and modify the app state through the AppStateNotifier.
// Notifier listens to changes in AppState and notifies any widgets that are subscribed to it.
final appStateProvider = NotifierProvider<AppStateNotifier, AppState>(
  AppStateNotifier
      .new, // Tells Riverpod: "When a provider is needed, create an AppStateNotifier."
);
// Derived providers
final todosProvider = Provider<List<Todo>>((ref) {
  return ref.watch(appStateProvider).todos;
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
