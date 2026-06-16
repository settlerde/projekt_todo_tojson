import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projekt_todo_tojson/providers/app_state_provider.dart';
import 'package:projekt_todo_tojson/widgets/add_todo_dialog.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            key: ValueKey(todo.id),
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (bool? checked) {
                (_) => ref.read(appStateProvider.notifier).toggleTodo(todo.id);
              },
            ),
            title: Text(
              todo.text,
              style: TextStyle(
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: todo.isCompleted ? Colors.grey : Colors.black,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            showDialog(context: context, builder: (_) => const AddTodoDialog()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
