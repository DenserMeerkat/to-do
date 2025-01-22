import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:to_do_app/components/components.dart';
import 'package:to_do_app/providers/providers.dart';
import 'todo/add_todo_button.dart';
import 'todo/logout_button.dart';
import 'todo/todo_list.dart';

@RoutePage()
class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          title: Row(
            children: [
              AppTitle(),
            ],
          ),
          trailing: [LogoutButton()],
        ),
      ],
      footers: [
        SizedBox(height: 12),
        Row(
          children: [
            Spacer(),
            AddTodoButton(userId: userId),
            gap(24),
          ],
        ),
        SizedBox(height: 16),
      ],
      child: TodoList(todos: todos, userId: userId),
    );
  }
}
