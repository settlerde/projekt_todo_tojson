import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projekt_todo_tojson/providers/main_providers.dart';

/// An overlay dialog component used to capture user input for generating new tasks.
///
/// This widget renders as an [AlertDialog] containing a structured text entry field.
/// It uses Riverpod's [ConsumerWidget] to gain access to [WidgetRef], enabling direct
/// interaction with the underlying business logic layer ([appStateProvider]).
/// It enforces input sanitization and manages soft keyboard lifecycle hooks automatically.
class AddTodoDialog extends ConsumerWidget {
  const AddTodoDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controller responsible for capturing and managing the text buffer lifecycle.
    final textController = TextEditingController();

    return AlertDialog(
      title: const Text('Add a task'),
      content: TextField(
        controller: textController,
        // UX Enhancement: Automatically requests focus to trigger soft keyboard initialization.
        autofocus: true,
        // UX Enhancement: Sets keyboard configuration to sentence-case capitalization layout.
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(hintText: 'What to do?', border: OutlineInputBorder()),
        // Trigger submission workflow directly from the hardware/virtual keyboard "Done/Enter" action.
        onSubmitted: (value) {
          _submitData(context, ref, textController.text);
        },
      ),
      actions: [
        // Cancellation interaction layer.
        TextButton(
          onPressed: () {
            // Dismiss the modal bottom sheet/dialog from the navigation stack without mutation.
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        // Confirmation interaction layer.
        ElevatedButton(
          onPressed: () {
            _submitData(context, ref, textController.text);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  /// Validates input string buffer, dispatches data mutations, and updates the view stack.
  ///
  /// Takes the current [context], the Riverpod [ref] provider bridge, and the raw input [text].
  /// Sanitizes the string using [String.trim] to guarantee zero white-space entry allocations.
  void _submitData(BuildContext context, WidgetRef ref, String text) {
    // Guards against empty strings or pure whitespace submissions.
    if (text.trim().isEmpty) return;

    // Dispatch action to update the immutable state tree with the newly initialized object.
    ref.read(appStateNotifierProvider).addTodo(text);

    // Pop the current route off the navigator stack to return user focus back to the primary view.
    Navigator.of(context).pop();
  }
}
