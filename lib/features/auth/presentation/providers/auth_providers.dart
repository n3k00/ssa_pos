import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:ssa/features/auth/domain/repositories/auth_repository.dart';
import 'package:ssa/shared/providers/app_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(ref.watch(firebaseAuthProvider));
});

final authStateChangesProvider = StreamProvider<bool>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});
