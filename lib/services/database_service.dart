import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:projekt_todo_tojson/models/todo.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'todos.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE todos(id TEXT PRIMARY KEY, text TEXT, isCompleted INTEGER)',
        );
        await db.execute(
          'CREATE TABLE settings(key TEXT PRIMARY KEY, value TEXT)',
        );
      },
    );
  }

  // CRUD — Create, Read, Update, Delete
  // add a task method
  Future<void> insertTodo(Todo todo) async {
    final db = await database;
    // SQL equivalent - INSERT INTO todos (id, text, isCompleted) VALUES (...)
    await db.insert('todos', {
      'id': todo.id,
      'text': todo.text,
      'isCompleted': todo.isCompleted ? 1 : 0,
    });
  }

  // get all tasks method
  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    final maps = await db.query(
      'todos',
    ); // SQL equivalent - SELECT * FROM todos

    return maps
        .map(
          (map) => Todo(
            id: map['id'] as String,
            text: map['text'] as String,
            isCompleted: (map['isCompleted'] as int) == 1,
          ),
        )
        .toList();
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    await db.update(
      'todos',
      {'text': todo.text, 'isCompleted': todo.isCompleted ? 1 : 0},
      where: 'id = ?', // says: "update only the row where the ID matches".
      whereArgs: [todo.id], // This is the value that is substituted for [?]
    );
  }

  Future<void> deleteTodo(String id) async {
    final db = await database;
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> saveSetting(String key, String value) async {
    final db = await database;
    await db.insert('settings', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final result = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) return null;
    return result.first['value'] as String;
  }
}
