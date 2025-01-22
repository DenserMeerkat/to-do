import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:to_do_app/services/hive_services.dart';
import 'routes/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await openHiveBoxes();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = AppRouter(AuthGuard(ref));

    return ShadcnApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ToDo',
      routerConfig: appRouter.config(),
      theme: ThemeData(
        colorScheme: ColorSchemes.slate(ThemeMode.light),
        radius: 0.75,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorSchemes.slate(ThemeMode.dark),
        radius: 0.75,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
