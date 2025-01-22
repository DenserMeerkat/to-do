import 'package:flutter/material.dart' as m;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/providers/providers.dart';

class AddTodoButton extends ConsumerStatefulWidget {
  const AddTodoButton({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  ConsumerState<AddTodoButton> createState() => _AddTodoButtonState();
}

class _AddTodoButtonState extends ConsumerState<AddTodoButton> {
  late final m.TextEditingController controller;
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

  @override
  Widget build(BuildContext context) {
    return IconButton.primary(
      density: ButtonDensity.icon,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(kAddTodoLabel),
            content: TextField(
              controller: controller,
              focusNode: focusNode,
            ),
            actions: [
              SecondaryButton(
                child: const Text(kCancelLabel),
                onPressed: () => Navigator.pop(context),
              ),
              PrimaryButton(
                child: const Text(kAddLabel),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    ref
                        .read(todoProvider.notifier)
                        .addTodo(widget.userId, controller.text);
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
    );
  }
}
