import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/material.dart' as m;
import 'package:to_do_app/models/models.dart';
import 'package:to_do_app/pages/todo/todo_card.dart';
import 'package:to_do_app/providers/providers.dart';

class TodoList extends ConsumerWidget {
  const TodoList({super.key, required this.todos, required this.userId});
  final List<Todo> todos;
  final String userId;

  void onDeleteTodo(WidgetRef ref, String userId, String id) {
    ref.read(todoProvider.notifier).deleteTodo(userId, id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Theme.of(context).colorScheme.border,
          ),
        ),
      ),
      child: m.ReorderableListView.builder(
        padding: EdgeInsets.zero,
        itemCount: todos.length,
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          ref
              .read(todoProvider.notifier)
              .reorderTodo(userId, oldIndex, newIndex);
        },
        proxyDecorator: (child, index, animation) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.muted,
          ),
          child: child,
        ),
        itemBuilder: (context, i) => TodoCard(
          key: ValueKey(todos[i].id),
          todo: todos[i],
          onDeleteTodo: (id) => onDeleteTodo(ref, userId, id),
          onTodoChanged: (todo) {
            ref.read(todoProvider.notifier).updateTodo(
                  userId,
                  todo.id,
                  title: todo.title,
                  isCompleted: todo.isCompleted,
                );
          },
        ),
      ),
    );
  }
}
