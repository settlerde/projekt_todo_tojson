import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projekt_todo_tojson/providers/app_state_provider.dart';
import 'package:projekt_todo_tojson/widgets/add_todo_dialog.dart';

/// A screen that displays the primary To-Do list interface.
///
/// This widget extends [ConsumerWidget] to integrate with the Riverpod
/// state management framework. It listens exclusively to [todosProvider]
/// to minimize unnecessary redraws, ensuring high rendering performance.
/// It provides users with the ability to toggle task completion states
/// and triggers the [AddTodoDialog] for new task creation.
class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Re-bind the widget to rebuild only when the underlying To-Do list changes.
    final todos = ref.watch(todosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      // Render an efficient scrollable list capable of handling large datasets.
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];

          return ListTile(
            // Use ValueKey to preserve widget state and optimize element recycling.
            key: ValueKey(todo.id),

            // Task status interaction layer.
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (bool? checked) {
                // Dispatch event to mutate the task completion state via the notifier.
                ref.read(appStateProvider.notifier).toggleTodo(todo.id);
              },
            ),

            // Task content presentation layer with conditional styling based on state.
            title: Text(
              todo.text,
              style: TextStyle(
                // Apply a line-through decoration to visually represent completed tasks.
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                // Dim the text color for completed tasks to shift user focus to active items.
                color: todo.isCompleted ? Colors.grey : Colors.black,
              ),
            ),
          );
        },
      ),

      // Floating Action Button to initiate the creation workflow.
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          // Ignore dialog builder context parameter as it is unutilized here.
          builder: (_) => const AddTodoDialog(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
