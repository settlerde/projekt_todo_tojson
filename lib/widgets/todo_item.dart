import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projekt_todo_tojson/models/todo.dart';
import 'package:projekt_todo_tojson/providers/main_providers.dart';

class TodoItem extends ConsumerWidget {
  final Todo todo;
  final bool isSelected;

  const TodoItem({super.key, required this.todo, required this.isSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      // Use ValueKey to preserve widget state and optimize element recycling.
      key: ValueKey(todo.id),
      selected: isSelected,
      selectedTileColor: colorScheme.primaryContainer.withAlpha(80),

      onLongPress: () {
        ref.read(appStateNotifierProvider).toggleSelection(todo.id);
      },
      // Task status interaction layer.
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: (bool? checked) {
          // Dispatch event to mutate the task completion state via the notifier.
          ref.read(appStateNotifierProvider).toggleTodo(todo.id);
        },
      ),

      // Task content presentation layer with conditional styling based on state.
      title: Text(
        todo.text,
        style: TextStyle(
          // Apply a line-through decoration to visually represent completed tasks.
          decoration: todo.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          // Dim the text color for completed tasks to shift user focus to active items.
          color: todo.isCompleted ? Colors.grey : colorScheme.onSurface,
        ),
      ),
      // UI Presentation Layer: Dynamically injects an explicit validation indicator.
      trailing: isSelected ? Icon(Icons.check_circle, color: colorScheme.primary) : null,
    );
  }
}
