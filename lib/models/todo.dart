import 'package:hive_flutter/hive_flutter.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)
class Todo {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Todo copyWith({
    String? title,
    bool? isCompleted,
  }) =>
      Todo(
        id: id,
        title: title ?? this.title,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
      };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'],
        title: json['title'],
        isCompleted: json['isCompleted'] as bool,
      );
}
