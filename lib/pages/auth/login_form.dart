import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:to_do_app/components/components.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/providers/providers.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _usernameKey = const FormKey<String>(#username);
  final _passwordKey = const FormKey<String>(#password);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          onSubmit: (context, values) async {
            final result = await ref.read(authProvider.notifier).signIn(
                values[_usernameKey] as String, values[_passwordKey] as String);
            if (!context.mounted) return;
            if (result) {
              context.router.replaceNamed('/todo');
            } else {
              showToast(
                  context: context,
                  builder: (context, overlay) => buildToast(
                        context,
                        overlay,
                        kErrorLabel,
                        kLoginErrorMessage,
                      ),
                  location: ToastLocation.topCenter);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kLoginLabel).semiBold(),
                  const Text(kLoginSubtitle).muted().small(),
                  const Gap(24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FormField<String>(
                          key: _usernameKey,
                          label: const Text(kUsernameLabel),
                          validator: const LengthValidator(min: 4),
                          padding: EdgeInsets.zero,
                          showErrors: const {
                            FormValidationMode.changed,
                            FormValidationMode.submitted
                          },
                          child: TextField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          )),
                      FormField<String>(
                        key: _passwordKey,
                        label: const Text(kPasswordLabel),
                        validator: const LengthValidator(min: 8),
                        showErrors: const {
                          FormValidationMode.changed,
                          FormValidationMode.submitted
                        },
                        child: PasswordField(),
                      ),
                    ],
                  ).gap(12),
                  const Gap(24),
                  FormErrorBuilder(
                    builder: (context, errors, child) {
                      return PrimaryButton(
                        onPressed:
                            errors.isEmpty ? () => context.submitForm() : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(kContinueLabel),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
