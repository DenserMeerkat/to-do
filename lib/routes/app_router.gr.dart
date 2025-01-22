// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AuthPage]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
      : super(
          AuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthPage();
    },
  );
}

/// generated route for
/// [TodoPage]
class TodoRoute extends PageRouteInfo<void> {
  const TodoRoute({List<PageRouteInfo>? children})
      : super(
          TodoRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TodoPage();
    },
  );
}
