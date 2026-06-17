/// This class represets a single Todo item in the App.
class Todo {
  final String id;
  final String text;
  final bool isCompleted;

  Todo({required this.id, required this.text, this.isCompleted = false});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Todo &&
        other.id == id &&
        other.text == text &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => Object.hash(id, text, isCompleted);

  // Create a copy with modified properties
  // This useful for immutability and state management, that creates a new instance of Todo with updated values,
  // without modifying original instance.
  // It will change only the properties that are passed, and keep the rest unchanged.
  Todo copyWith({String? id, String? text, bool? isCompleted}) {
    return Todo(
      id: id ?? this.id,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'isCompleted': isCompleted};
  }

  // Create Todo from JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      text: json['text'],
      isCompleted: json['isCompleted'],
    );
  }
}
