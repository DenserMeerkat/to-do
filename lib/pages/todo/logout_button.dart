import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
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
              title: const Text('Logout'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Are you sure you want to logout?'),
                ],
              ),
              actions: [
                SecondaryButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                PrimaryButton(
                  child: const Text('Logout'),
                  onPressed: () {
                    ref.read(authProvider.notifier).signOut();
                    context.router.replaceNamed('/auth');
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
