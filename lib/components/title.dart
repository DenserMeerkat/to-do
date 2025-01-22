import 'package:shadcn_flutter/shadcn_flutter.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(RadixIcons.checkCircled),
        Text('ToDo'),
      ],
    ).gap(8);
  }
}
