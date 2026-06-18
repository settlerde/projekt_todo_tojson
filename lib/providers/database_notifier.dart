import 'package:projekt_todo_tojson/models/app_state.dart';
import 'package:projekt_todo_tojson/services/database_service.dart';
import 'package:projekt_todo_tojson/providers/app_state_notifier_interface.dart';
import 'package:projekt_todo_tojson/models/todo.dart';

/// A notifier class that manages the application state and synchronizes
/// data persistence using [DatabaseService].
class DatabaseNotifier extends AppStateNotifierInterface {
  final _databaseService = DatabaseService();

  @override
  AppState build() {
    // Schedules state loading asynchronously after the current frame execution.
    Future.microtask(() => loadState());
    return AppState();
  }

  @override
  Future<void> loadState() async {
    final todos = await _databaseService.getAllTodos();
    final isDarkModeStr = await _databaseService.getSetting('isDarkMode');
    final asksConfirmation = await _databaseService.getSetting(
      'asksForDeletionConfirmation',
    );

    // Map database values into the application state.
    state = state.copyWith(
      todos: todos,
      isDarkMode: isDarkModeStr == '1',
      asksForDeletionConfirmation: asksConfirmation != '0',
    );
  }

  @override
  Future<void> saveState() async {
    // This method remains empty because state persistence is handled
    // granularly by each atomic action (e.g., addTodo, toggleTodo).
  }

  @override
  void addTodo(String text) {
    if (text.trim().isEmpty) return;

    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isCompleted: false,
    );

    state = state.copyWith(todos: [...state.todos, newTodo]);
    _databaseService.insertTodo(newTodo);
  }

  @override
  void toggleTodo(String id) {
    Todo? updatedTodo;

    state = state.copyWith(
      todos: state.todos.map((todo) {
        if (todo.id == id) {
          updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
          return updatedTodo!;
        }
        return todo;
      }).toList(),
    );

    // Synchronize the updated item with the local SQLite database.
    if (updatedTodo != null) {
      _databaseService.updateTodo(updatedTodo!);
    }
  }

  @override
  void toggleDarkMode() {
    final newMode = !state.isDarkMode;
    state = state.copyWith(isDarkMode: newMode);
    _databaseService.saveSetting('isDarkMode', newMode ? '1' : '0');
  }

  @override
  void toggleDeletionConfirmation() {
    final newConfirmation = !state.asksForDeletionConfirmation;
    state = state.copyWith(asksForDeletionConfirmation: newConfirmation);
    _databaseService.saveSetting(
      'asksForDeletionConfirmation',
      newConfirmation ? '1' : '0',
    );
  }

  // --- SELECTION & BULK OPERATIONS ---

  @override
  void toggleSelection(String id) {
    // Create a new Set instance to maintain immutability principles.
    final currentSelected = Set<String>.from(state.selectedTodoIds);

    if (currentSelected.contains(id)) {
      currentSelected.remove(id);
    } else {
      currentSelected.add(id);
    }

    state = state.copyWith(selectedTodoIds: currentSelected);
  }

  @override
  void clearSelection() {
    state = state.copyWith(selectedTodoIds: {});
  }

  @override
  Future<void> deleteSelectedTodos() async {
    final selectedIds = state.selectedTodoIds;
    if (selectedIds.isEmpty) return;

    // 1. Locally filter out the items marked for deletion.
    final remainingTodos = state.todos
        .where((todo) => !selectedIds.contains(todo.id))
        .toList();

    state = state.copyWith(
      todos: remainingTodos,
      selectedTodoIds: {}, // Reset selection after successful deletion.
    );

    // 2. Persist changes by deleting records from the database.
    for (final id in selectedIds) {
      await _databaseService.deleteTodo(id);
    }
  }
}
