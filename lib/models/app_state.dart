import 'package:projekt_todo_tojson/models/todo.dart';
import 'package:collection/collection.dart';

/// This class is State Management of the App,
/// it holds the state of the app, includs the list of todos,
/// the theme mode, and the delition confirmation setting.
/// It also provides methods to create a copy of the state with modified properties (copyWith).
class AppState {
  final List<Todo> todos;
  final bool isDarkMode;
  final bool asksForDeletionConfirmation;
  final Set<String> selectedTodoIds; // For tracking selected items

  AppState({
    this.todos = const [],
    this.isDarkMode = false,
    this.asksForDeletionConfirmation = true,
    this.selectedTodoIds = const {},
  });

  // Create a copy with modified properties
  AppState copyWith({
    List<Todo>? todos,
    bool? isDarkMode,
    bool? asksForDeletionConfirmation,
    Set<String>? selectedTodoIds,
  }) {
    return AppState(
      todos: todos ?? this.todos,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      asksForDeletionConfirmation:
          asksForDeletionConfirmation ?? this.asksForDeletionConfirmation,
      selectedTodoIds: selectedTodoIds ?? this.selectedTodoIds,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'todos': todos.map((todo) => todo.toJson()).toList(),
      'isDarkMode': isDarkMode,
      'asksForDeletionConfirmation': asksForDeletionConfirmation,
      // We don't persist selection state
    };
  }

  // Create AppState from JSON
  factory AppState.fromJson(Map<String, dynamic> json) {
    return AppState(
      todos: (json['todos'] as List)
          .map((todoJson) => Todo.fromJson(todoJson))
          .toList(),
      isDarkMode: json['isDarkMode'] ?? false,
      asksForDeletionConfirmation: json['asksForDeletionConfirmation'] ?? true,
    );
  }
  @override
  bool operator ==(Object other) {
    // Structural Guard: Immediately return true if instances point to the exact same memory reference.
    if (identical(this, other)) return true;

    // Type Guard: Return false if the comparison object is null or built from a mismatching runtime type.
    return other is AppState &&
        // Deep-compare list collections recursively utilizing deep-element comparison mechanics.
        const ListEquality<Todo>().equals(other.todos, todos) &&
        // Shallow-compare primitive types.
        other.isDarkMode == isDarkMode &&
        other.asksForDeletionConfirmation == asksForDeletionConfirmation &&
        // Deep-compare set collections utilizing hashed element validation mechanics.
        const SetEquality<String>().equals(
          other.selectedTodoIds,
          selectedTodoIds,
        );
  }

  /// Hash code generator tracking value allocations recursively.
  ///
  /// State verification layer: Generates a combined state map fingerprint.
  /// Combines deep-collection hash metrics with primitive value hash references
  /// to ensure immutable caching mechanisms function with zero collision margins.
  @override
  int get hashCode {
    return Object.hash(
      // Compute the deep hash map of the nested list elements.
      const ListEquality<Todo>().hash(todos),
      isDarkMode,
      asksForDeletionConfirmation,
      // Compute the deep hash map of the nested set elements.
      const SetEquality<String>().hash(selectedTodoIds),
    );
  }
}
