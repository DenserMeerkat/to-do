import 'package:shadcn_flutter/shadcn_flutter.dart';

class PasswordField extends TextField {
  const PasswordField({super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: !_isVisible,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      trailing: IconButton.ghost(
        onPressed: () {
          setState(() {
            _isVisible = !_isVisible;
          });
        },
        density: ButtonDensity.icon,
        size: ButtonSize.small,
        icon: Icon(
          _isVisible
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: Theme.of(context).colorScheme.mutedForeground,
        ),
      ),
    );
  }
}
