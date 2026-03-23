import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/features/auth/domain/repositories/auth_repository.dart';
import 'package:ssa/features/auth/presentation/pages/auth_gate_page.dart';
import 'package:ssa/features/auth/presentation/providers/auth_providers.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this._controller);

  final StreamController<bool> _controller;

  @override
  Stream<bool> authStateChanges() => _controller.stream;

  @override
  String? currentPhoneNumber() => '09123456789';

  @override
  Future<void> signInWithPhoneAndPassword({
    required String phone,
    required String password,
  }) async {}

  @override
  Future<void> signOut() async {}
}

void main() {
  testWidgets('shows login page when unauthenticated', (tester) async {
    final controller = StreamController<bool>();
    addTearDown(controller.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository(controller)),
          authStateChangesProvider.overrideWith((ref) => controller.stream),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const AuthGatePage(),
        ),
      ),
    );

    controller.add(false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));

    expect(find.text(AppStrings.loginTitle), findsWidgets);
  });
}
