abstract class AuthRepository {
  Stream<bool> authStateChanges();
  String? currentPhoneNumber();

  Future<void> signInWithPhoneAndPassword({
    required String phone,
    required String password,
  });

  Future<void> signOut();
}
