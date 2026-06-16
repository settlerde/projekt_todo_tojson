import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projekt_todo_tojson/providers/app_state_provider.dart';
/// 
class AddTodoDialog extends ConsumerWidget {
  const AddTodoDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controller for tracking text entered by the user
    final textController = TextEditingController();

    return AlertDialog(
      title: const Text('Add a task'),
      content: TextField(
        controller: textController,
        autofocus:
            true, // The keyboard will open automatically when the dialog appears.
        textCapitalization:
            TextCapitalization.sentences, // First letter will be capitalized
        decoration: const InputDecoration(
          hintText: 'What to do?',
          border: OutlineInputBorder(),
        ),
        // Allows adding a task by pressing the "Enter" key on the keyboard.
        onSubmitted: (value) {
          _submitData(context, ref, textController.text);
        },
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // close dialog
          },
          child: const Text('Cancel'),
        ),
        // Add button
        ElevatedButton(
          onPressed: () {
            _submitData(context, ref, textController.text);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  // moved the sending logic into a separate private method so as not to duplicate the code
  void _submitData(BuildContext context, WidgetRef ref, String text) {
    if (text.trim().isEmpty) return; // not adding empty tasks

    // calls a notifier's method to add a task.
    ref.read(appStateProvider.notifier).addTodo(text);

    // Closes the dialog box after adding.
    Navigator.of(context).pop();
  }
}
