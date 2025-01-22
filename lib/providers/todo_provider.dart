import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../services/hive_services.dart';
import '../utils/utils.dart';

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);

  Future<void> loadTodos(String userId) async {
    final todosJson = await hiveHandler.getUserTodos(userId);
    state = todosJson.map((json) => Todo.fromJson(json)).toList();
  }

  Future<void> addTodo(String userId, String title,
      {bool isCompleted = false}) async {
    final todo = Todo(
      id: getNewUuid(),
      title: title,
      isCompleted: isCompleted,
    );

    await hiveHandler.setTodo(userId, todo.id, todo.toJson());
    state = [...state, todo];
  }

  Future<void> updateTodo(String userId, String todoId,
      {String? title, bool? isCompleted}) async {
    state = state.map((todo) {
      if (todo.id == todoId) {
        final updatedTodo = todo.copyWith(
          title: title,
          isCompleted: isCompleted,
        );
        hiveHandler.setTodo(userId, todoId, updatedTodo.toJson());
        return updatedTodo;
      }
      return todo;
    }).toList();
  }

  Future<void> deleteTodo(String userId, String todoId) async {
    await hiveHandler.deleteTodo(userId, todoId);
    state = state.where((todo) => todo.id != todoId).toList();
  }

  Future<void> clearTodos(String userId) async {
    await hiveHandler.clearUserTodos(userId);
    state = [];
  }
}
