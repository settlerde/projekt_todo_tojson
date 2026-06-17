import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projekt_todo_tojson/providers/app_state_provider.dart';
import 'package:projekt_todo_tojson/widgets/add_todo_dialog.dart';
import 'package:projekt_todo_tojson/screens/settings_screen.dart';
import 'package:projekt_todo_tojson/widgets/todo_item.dart';

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
    final hasSelected = ref.watch(hasSelectedTodosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          // The delete icon only appears when there is something to delete.
          if (hasSelected)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Check the user's preference: should we ask for confirmation
                // before deleting, or just delete immediately?
                final asksConfirmation = ref
                    .read(appStateProvider)
                    .asksForDeletionConfirmation;

                if (asksConfirmation) {
                  // Show a confirmation dialog before performing the deletion.
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text(
                        'Are you sure you want to delete the selected items?',
                      ),
                      actions: [
                        // Cancel button — closes the dialog, nothing happens.
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        // Delete button — performs the actual deletion via the notifier.
                        TextButton(
                          onPressed: () {
                            ref
                                .read(appStateProvider.notifier)
                                .deleteSelectedTodos();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Confirmation disabled in settings — delete right away
                  ref.read(appStateProvider.notifier).deleteSelectedTodos();
                }
              },
            ),
          // Navigation layer: Injects a direct transition route to the app settings panel.
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Open Settings',
            onPressed: () {
              // Push the SettingsScreen onto the global application routing stack.
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      // Render an efficient scrollable list capable of handling large datasets.
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          final selectedIds = ref.watch(selectedTodosProvider);
          final isSelected = selectedIds.contains(todo.id);

          return TodoItem(todo: todo, isSelected: isSelected);
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
