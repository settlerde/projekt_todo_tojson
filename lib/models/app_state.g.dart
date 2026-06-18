// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppState _$AppStateFromJson(Map<String, dynamic> json) => _AppState(
  todos:
      (json['todos'] as List<dynamic>?)
          ?.map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isDarkMode: json['isDarkMode'] as bool? ?? false,
  asksForDeletionConfirmation:
      json['asksForDeletionConfirmation'] as bool? ?? true,
  selectedTodoIds:
      (json['selectedTodoIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toSet() ??
      const {},
);

Map<String, dynamic> _$AppStateToJson(_AppState instance) => <String, dynamic>{
  'todos': instance.todos,
  'isDarkMode': instance.isDarkMode,
  'asksForDeletionConfirmation': instance.asksForDeletionConfirmation,
  'selectedTodoIds': instance.selectedTodoIds.toList(),
};
