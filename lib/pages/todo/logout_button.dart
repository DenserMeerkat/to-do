import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/providers/providers.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlineButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(kLogoutLabel),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(kLogoutConfirmationMessage),
                ],
              ),
              actions: [
                SecondaryButton(
                  child: const Text(kCancelLabel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                PrimaryButton(
                  child: const Text(kLogoutLabel),
                  onPressed: () {
                    ref.read(authProvider.notifier).signOut();
                  },
                ),
              ],
            );
          },
        );
      },
      density: ButtonDensity.icon,
      size: ButtonSize.small,
      child: const Icon(Icons.logout),
    );
  }
}
