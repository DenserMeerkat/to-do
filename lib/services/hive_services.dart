import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String kUserBox = "users";

Future<void> openHiveBoxes() async {
  try {
    await Hive.initFlutter();
    await Hive.openBox(kUserBox);
  } catch (e) {
    debugPrint("Error opening Hive boxes: $e");
  }
}

final hiveHandler = HiveHandler();

class HiveHandler {
  late final Box userBox;
  final Map<String, Box> _todoBoxes = {};

  HiveHandler() {
    debugPrint("Trying to open Hive boxes");
    userBox = Hive.box(kUserBox);
  }

  dynamic getUser(String id) => userBox.get(id);
  Future<void> setUser(String id, Map<String, dynamic> userJson) =>
      userBox.put(id, userJson);

  Future<Box> _getTodoBox(String userId) async {
    if (!_todoBoxes.containsKey(userId)) {
      final boxName = 'todos_$userId';
      _todoBoxes[userId] = await Hive.openBox(boxName);
    }
    return _todoBoxes[userId]!;
  }

  Future<dynamic> getTodo(String userId, String todoId) async {
    final box = await _getTodoBox(userId);
    return box.get(todoId);
  }

  Future<void> setTodo(
      String userId, String todoId, Map<String, dynamic> todoJson) async {
    final box = await _getTodoBox(userId);
    await box.put(todoId, todoJson);

    final orderIds = box.get('order', defaultValue: <String>[]) as List;
    if (!orderIds.contains(todoId)) {
      orderIds.add(todoId);
      await box.put('order', orderIds);
    }
  }

  Future<List<Map<String, dynamic>>> getUserTodos(String userId) async {
    final box = await _getTodoBox(userId);
    final orderIds = box.get('order', defaultValue: <String>[]) as List;

    if (orderIds.isEmpty) {
      final todos = box.values
          .whereType<Map<dynamic, dynamic>>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      final ids = todos.map((todo) => todo['id'] as String).toList();
      await box.put('order', ids);
      return todos;
    }

    return orderIds
        .map((id) => box.get(id))
        .whereType<Map<dynamic, dynamic>>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> deleteTodo(String userId, String todoId) async {
    final box = await _getTodoBox(userId);
    await box.delete(todoId);

    final orderIds = box.get('order', defaultValue: <String>[]) as List;
    orderIds.remove(todoId);
    await box.put('order', orderIds);
  }

  Future<void> clearUserTodos(String userId) async {
    final boxName = 'todos_$userId';
    if (await Hive.boxExists(boxName)) {
      final box = await Hive.openBox(boxName);
      await box.clear();
      await box.close();
      _todoBoxes.remove(userId);
    }
  }

  Future<void> clearAll() async {
    await userBox.clear();
    for (var box in _todoBoxes.values) {
      await box.clear();
      await box.close();
    }
    _todoBoxes.clear();
  }

  Future<void> openTodoBox(String userId) async {
    await _getTodoBox(userId);
  }

  Future<void> closeTodoBox(String userId) async {
    if (_todoBoxes.containsKey(userId)) {
      final box = _todoBoxes[userId]!;
      await box.close();
      _todoBoxes.remove(userId);
    }
  }

  Future<void> reorderTodos(String userId, List<String> newOrder) async {
    final box = await _getTodoBox(userId);
    await box.put('order', newOrder);
  }
}
