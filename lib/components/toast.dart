import 'package:shadcn_flutter/shadcn_flutter.dart';

Widget buildToast(
    BuildContext context, ToastOverlay overlay, String title, String subtitle,
    {Widget? trailing}) {
  return SurfaceCard(
    filled: true,
    child: Basic(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ??
          PrimaryButton(
            onPressed: () {
              overlay.close();
            },
            size: ButtonSize.small,
            density: ButtonDensity.icon,
            child: const Icon(Icons.close),
          ),
      trailingAlignment: Alignment.center,
    ),
  );
}
