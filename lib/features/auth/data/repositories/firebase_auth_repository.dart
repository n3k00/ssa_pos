import 'package:firebase_auth/firebase_auth.dart';
import 'package:ssa/core/utils/phone_normalizer.dart';
import 'package:ssa/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  const FirebaseAuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Stream<bool> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) => user != null);
  }

  @override
  String? currentPhoneNumber() {
    return PhoneNormalizer.phoneFromAuthEmail(_firebaseAuth.currentUser?.email);
  }

  @override
  Future<void> signInWithPhoneAndPassword({
    required String phone,
    required String password,
  }) async {
    final normalizedPhone = PhoneNormalizer.normalizeMyanmarPhone(phone);
    final email = PhoneNormalizer.toAuthEmail(normalizedPhone);
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
