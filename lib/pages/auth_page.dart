import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:to_do_app/components/components.dart';
import 'package:to_do_app/pages/auth/login_form.dart';
import 'package:to_do_app/pages/auth/signup_form.dart';
import 'package:to_do_app/providers/providers.dart';

@RoutePage()
class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with TickerProviderStateMixin {
  late final m.TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = m.TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      loadingProgressIndeterminate: ref.watch(isAuthLoadingProvider),
      headers: [
        AppBar(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          title: Row(
            children: [
              AppTitle(),
            ],
          ),
        ),
        const Divider(),
      ],
      footers: [
        const Divider(),
        NavigationBar(
          onSelected: (index) {
            setState(() {
              _tabController.index = index;
            });
          },
          index: _tabController.index,
          children: [
            NavigationButton(
              label: Text('Login'),
              child: Text('Login'),
            ),
            NavigationButton(
              label: Text('Signup'),
              child: Text('Signup'),
            ),
          ],
        ),
      ],
      child: m.TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          LoginForm(),
          SignUpForm(tabController: _tabController),
        ],
      ),
    );
  }
}
