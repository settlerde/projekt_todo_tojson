import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:projekt_todo_tojson/models/app_state.dart';

class StorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/todo_app_state.json');
  }

  Future<void> saveAppState(AppState state) async {
    final file = await _localFile;
    final jsonString = jsonEncode(state.toJson());
    await file.writeAsString(jsonString);
  }

  Future<AppState?> loadAppState() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return null;
      }

      final jsonString = await file.readAsString();
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppState.fromJson(jsonMap);
    } catch (e) {
      print('Error loading app state: $e');
      return null;
    }
  }
}
