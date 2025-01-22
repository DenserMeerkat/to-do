import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/todo.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({
    super.key,
    required this.todo,
    required this.onTodoChanged,
    required this.onDeleteTodo,
  });

  final Todo todo;
  final Function(Todo) onTodoChanged;
  final Function(String) onDeleteTodo;

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  late final TextEditingController controller;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.todo.title);
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.border,
          ),
        ),
      ),
      child: Row(
        children: [
          gap(4),
          Checkbox(
            state: widget.todo.isCompleted
                ? CheckboxState.checked
                : CheckboxState.unchecked,
            onChanged: (state) => widget.onTodoChanged(
              widget.todo.copyWith(isCompleted: state == CheckboxState.checked),
            ),
          ),
          Expanded(
            child: Text(
              widget.todo.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton.ghost(
            size: ButtonSize.small,
            density: ButtonDensity.icon,
            onPressed: () {
              showDropdown(
                context: context,
                builder: (context) {
                  return DropdownMenu(
                    children: [
                      MenuButton(
                        onPressed: (context) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(kEditTodoLabel),
                              content: TextField(
                                controller: controller,
                                focusNode: focusNode,
                              ),
                              actions: [
                                SecondaryButton(
                                  child: const Text(kCancelLabel),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                PrimaryButton(
                                  child: const Text(kSaveLabel),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    widget.onTodoChanged(
                                      widget.todo.copyWith(
                                        title: controller.text,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        leading: const Icon(RadixIcons.pencil2),
                        child: const Text(kEditLabel),
                      ),
                      MenuDivider(),
                      MenuButton(
                        onPressed: (context) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(kDeleteTodoLabel),
                              content:
                                  const Text(kDeleteTodoConfirmationMessage),
                              actions: [
                                SecondaryButton(
                                  child: const Text(kCancelLabel),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                PrimaryButton(
                                  child: const Text(kDeleteLabel),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    widget.onDeleteTodo(widget.todo.id);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        leading: const Icon(RadixIcons.trash),
                        child: const Text(kDeleteLabel),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.more_horiz),
          ),
          gap(8),
        ],
      ),
    );
  }
}
