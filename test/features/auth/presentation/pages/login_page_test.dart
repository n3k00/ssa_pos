import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/features/auth/domain/repositories/auth_repository.dart';
import 'package:ssa/features/auth/presentation/pages/login_page.dart';
import 'package:ssa/features/auth/presentation/providers/auth_providers.dart';

class _FakeAuthRepository implements AuthRepository {
  bool called = false;

  @override
  Stream<bool> authStateChanges() => const Stream<bool>.empty();

  @override
  String? currentPhoneNumber() => '09123456789';

  @override
  Future<void> signInWithPhoneAndPassword({
    required String phone,
    required String password,
  }) async {
    called = true;
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  testWidgets('shows invalid phone validation and blocks sign in', (tester) async {
    final repo = _FakeAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const LoginPage(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), '08123456789');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.invalidPhoneNumber), findsOneWidget);
    expect(repo.called, isFalse);
  });
}
