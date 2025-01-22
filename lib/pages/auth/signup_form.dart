import 'package:flutter/material.dart' as m;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:to_do_app/components/components.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/providers/providers.dart';

class SignUpForm extends ConsumerStatefulWidget {
  final m.TabController tabController;
  const SignUpForm({super.key, required this.tabController});
  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _usernameKey = const FormKey<String>(#username);
  final _passwordKey = const FormKey<String>(#password);
  final _confirmPasswordKey = const FormKey<String>(#confirmPassword);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          onSubmit: (context, values) async {
            final result = await ref.read(authProvider.notifier).signUp(
                values[_usernameKey] as String, values[_passwordKey] as String);
            if (!context.mounted) return;
            if (result) {
              showToast(
                  context: context,
                  builder: (context, overlay) => buildToast(
                        context,
                        overlay,
                        kSuccessLabel,
                        kSignUpSuccessMessage,
                      ),
                  location: ToastLocation.topCenter);
              widget.tabController.animateTo(0);
            } else {
              showToast(
                  context: context,
                  builder: (context, overlay) => buildToast(
                        context,
                        overlay,
                        kErrorLabel,
                        kSignUpErrorMessage,
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
                  Text(kSignupLabel).semiBold(),
                  const Text(kSignupSubtitle).muted().small(),
                  const Gap(24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FormField<String>(
                        key: _usernameKey,
                        label: const Text(kUsernameLabel),
                        validator: const LengthValidator(min: 4),
                        showErrors: const {
                          FormValidationMode.changed,
                          FormValidationMode.submitted
                        },
                        child: TextField(
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
                      ),
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
                      FormField<String>(
                        key: _confirmPasswordKey,
                        label: const Text(kConfirmPasswordLabel),
                        validator: CompareWith.equal(_passwordKey,
                            message: kPasswordMismatchMessage),
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
