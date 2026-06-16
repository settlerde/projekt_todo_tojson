import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:projekt_todo_tojson/models/app_state.dart';

/// This service is responsible foe saving and loading the app state
/// to and from the devices storage. Uses the path_provider package to get correct directory.
class StorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Returnss a file object representing the location of JSON file where the app state will be stored.
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/todo_app_state.json');
  }

  // Saves the app state as a JSON string to the file.
  Future<void> saveAppState(AppState state) async {
    final file = await _localFile;
    final jsonString = jsonEncode(state.toJson());
    await file.writeAsString(jsonString);
  }

  // loads the app state from the file, decodes the JSON string,
  // and returns an AppState object. If not, it returns NULL.
  Future<AppState?> loadAppState() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return null;
      }
      // Reads the JSON string from file and decodes it into Map,
      // thn creates an AppState object using fromJson factory constructor.
      final jsonString = await file.readAsString();
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppState.fromJson(jsonMap);
    } catch (e) {
      print('Error loading app state: $e');
      return null;
    }
  }
}
