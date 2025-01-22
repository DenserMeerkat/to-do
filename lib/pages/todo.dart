import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/material.dart' as m;
import 'package:to_do_app/components/components.dart';
import 'package:to_do_app/pages/todo/todo_card.dart';
import 'package:to_do_app/providers/providers.dart';
import 'todo/logout_button.dart';

@RoutePage()
class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  late final TextEditingController controller;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void onDeleteTodo(String userId, String id) {
    ref.read(todoProvider.notifier).deleteTodo(userId, id);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.router.replaceNamed('/auth');
        }
      });
      return const SizedBox.shrink();
    }

    final todos = ref.watch(todoProvider);
    final userId = user.id;

    return Scaffold(
      headers: [
        AppBar(
          title: AppTitle(),
          trailing: [LogoutButton()],
        ),
      ],
      footers: [
        SizedBox(height: 12),
        Row(
          children: [
            Spacer(),
            IconButton.primary(
              density: ButtonDensity.icon,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Add Todo'),
                    content: TextField(
                      controller: controller,
                      focusNode: focusNode,
                    ),
                    actions: [
                      SecondaryButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      PrimaryButton(
                        child: const Text('Add'),
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            ref
                                .read(todoProvider.notifier)
                                .addTodo(userId, controller.text);
                            controller.clear();
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
            gap(24),
          ],
        ),
        SizedBox(height: 16),
      ],
      child: Container(
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
            onDeleteTodo: (id) => onDeleteTodo(userId, id),
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
      ),
    );
  }
}
