import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projekt_todo_tojson/providers/app_state_provider.dart';

/// A configuration interface that exposes global application preferences.
///
/// This screen maps UI controls directly to persistent user configuration keys
/// managed within [appStateProvider]. It updates settings instantly upon user
/// interaction and dispatches operations directly to the local storage pipeline.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the current state configurations reactively.
    final isDarkMode = ref.watch(
      // [select] says: "watch only for [isDarkMode]; the other changes don't concern me"
      appStateProvider.select((state) => state.isDarkMode),
    );
    final asksForConfirmation = ref.watch(
      appStateProvider.select((state) => state.asksForDeletionConfirmation),
    );

    // Obtain the command channel notifier to commit preference adjustments.
    final stateNotifier = ref.read(appStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        // Note: Flutter natively handles the back navigation button injection
        // if this route is pushed onto the global Navigator framework stack.
      ),
      body: ListView(
        physics:
            const ClampingScrollPhysics(), // Prevents unnecessary bouncing animations on small lists
        children: [
          // Theme configuration sector.
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle between light and dark visual themes'),
            secondary: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: isDarkMode ? Colors.amber : Colors.grey,
            ),
            value: isDarkMode,
            onChanged: (bool value) {
              stateNotifier.toggleDarkMode();
            },
          ),

          const Divider(height: 1), // Standard visual boundary segment
          // User Experience guardrail configuration sector.
          SwitchListTile(
            title: const Text('Confirm Deletion'),
            subtitle: const Text(
              'Require confirmation dialog before executing batch item deletes',
            ),
            secondary: const Icon(Icons.playlist_remove),
            value: asksForConfirmation,
            onChanged: (bool value) {
              stateNotifier.toggleDeletionConfirmation();
            },
          ),
        ],
      ),
    );
  }
}
