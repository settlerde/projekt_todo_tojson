import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

/// This class represets a single Todo item in the App.
@freezed
abstract class Todo with _$Todo {
  factory Todo({
    required String id,
    required String text,
    required bool isCompleted,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
