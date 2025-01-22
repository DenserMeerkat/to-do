import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/hive_services.dart';
import '../utils/utils.dart';
import '../providers/todo_provider.dart';
import 'ui_providers.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<User?> {
  final Ref ref;
  AuthNotifier(this.ref) : super(null);

  bool isSignedIn() {
    return state != null;
  }

  List<User> _getExistingUsers() {
    return hiveHandler.userBox.values.map((json) {
      final Map<String, dynamic> userMap =
          Map<String, dynamic>.from(json as Map);
      return User.fromJson(userMap);
    }).toList();
  }

  Future<bool> signUp(String username, String password) async {
    ref.read(isAuthLoadingProvider.notifier).state = true;
    final existingUsers = _getExistingUsers();

    if (existingUsers
        .any((user) => user.username.toLowerCase() == username.toLowerCase())) {
      ref.read(isAuthLoadingProvider.notifier).state = false;
      return false;
    }

    final user = User(
      id: getNewUuid(),
      username: username,
      passwordHash: hashPassword(password),
    );

    await hiveHandler.setUser(user.id, user.toJson());
    await hiveHandler.openTodoBox(user.id);
    state = user;
    ref.read(isAuthLoadingProvider.notifier).state = false;
    return true;
  }

  void signOut() {
    hiveHandler.closeTodoBox(state!.id);
    state = null;
    ref.read(todoProvider.notifier).state = [];
  }

  Future<bool> signIn(String username, String password) async {
    ref.read(isAuthLoadingProvider.notifier).state = true;
    final existingUsers = _getExistingUsers();

    final user = existingUsers.cast<User?>().firstWhere(
          (user) => user?.username.toLowerCase() == username.toLowerCase(),
          orElse: () => null,
        );

    if (user != null && verifyPassword(password, user.passwordHash)) {
      state = user;
      await hiveHandler.openTodoBox(user.id);
      await ref.read(todoProvider.notifier).loadTodos(user.id);
      ref.read(isAuthLoadingProvider.notifier).state = false;
      return true;
    }
    ref.read(isAuthLoadingProvider.notifier).state = false;
    return false;
  }
}
