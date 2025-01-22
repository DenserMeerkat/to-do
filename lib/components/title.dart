import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:to_do_app/constants.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.muted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(RadixIcons.checkCircled),
          gap(8),
          Text(kAppName),
        ],
      ),
    );
  }
}
