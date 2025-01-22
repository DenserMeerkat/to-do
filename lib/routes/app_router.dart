import 'package:auto_route/auto_route.dart';
import 'package:to_do_app/pages/auth_page.dart';
import 'package:to_do_app/pages/todo_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;

  AppRouter(this.authGuard);

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: AuthRoute.page, path: '/auth'),
        AutoRoute(
          page: TodoRoute.page,
          path: '/todo',
          initial: true,
          guards: [authGuard],
        ),
      ];
}

class AuthGuard extends AutoRouteGuard {
  final WidgetRef ref;

  AuthGuard(this.ref);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (ref.read(authProvider.notifier).isSignedIn()) {
      resolver.next(true);
    } else {
      resolver.next(false);
      router.replace(const AuthRoute());
    }
  }
}
