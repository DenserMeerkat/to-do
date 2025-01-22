import 'package:auto_route/auto_route.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:to_do_app/components/components.dart';

import 'todo/logout_button.dart';

@RoutePage()
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          title: AppTitle(),
          trailing: [
            LogoutButton(),
          ],
        ),
        const Divider(),
      ],
      child: const Center(
        child: Text('Todo'),
      ),
    );
  }
}
