import 'package:freezed_annotation/freezed_annotation.dart';
import 'todo.dart';

part 'app_state.freezed.dart';
part 'app_state.g.dart';

/// Represents the immutable global state of the Todo application.
/// 
/// This data class uses the Freezed package for code generation, ensuring
/// strict immutability, built-in value equality, and seamless JSON serialization.
@freezed
abstract class AppState with _$AppState {
  /// Creates an instance of [AppState] with predefined default values.
  ///
  /// * [todos] - The complete list of current todo items fetched from the storage.
  /// * [isDarkMode] - A flag indicating whether the dark user interface theme is active.
  /// * [asksForDeletionConfirmation] - Determines if a confirmation dialog should 
  ///   be displayed before removing data.
  /// * [selectedTodoIds] - A unique set of item IDs currently marked by the user 
  ///   for bulk operations.
  factory AppState({
    @Default([]) List<Todo> todos,
    @Default(false) bool isDarkMode,
    @Default(true) bool asksForDeletionConfirmation,
    @Default({}) Set<String> selectedTodoIds,
  }) = _AppState;

  /// De-serializes an [AppState] instance from a standard JSON map structure.
  factory AppState.fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);
}