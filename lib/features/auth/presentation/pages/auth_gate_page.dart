import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/features/auth/presentation/providers/auth_providers.dart';
import 'package:ssa/features/pos/presentation/pages/pos_home_page.dart';
import 'package:ssa/features/auth/presentation/pages/login_page.dart';

class AuthGatePage extends ConsumerWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (isAuthenticated) {
        if (isAuthenticated) {
          return const PosHomePage();
        }
        return const LoginPage();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.pagePadding),
            child: Text(AppStrings.authStateError),
          ),
        ),
      ),
    );
  }
}
