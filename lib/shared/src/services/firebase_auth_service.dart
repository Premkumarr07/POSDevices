import 'dart:async';

class FirebaseAuthUser {
  FirebaseAuthUser({required this.uid, required this.email});

  final String uid;
  final String email;
}

class FirebaseAuthCredential {
  FirebaseAuthCredential({required this.user});

  final FirebaseAuthUser user;
}

class FirebaseAuthService {
  FirebaseAuthService();

  final StreamController<FirebaseAuthUser?> _authState =
      StreamController<FirebaseAuthUser?>.broadcast();

  FirebaseAuthUser? _currentUser;

  FirebaseAuthUser? get currentUser => _currentUser;
  String? get currentUserId => _currentUser?.uid;
  String? get currentUserEmail => _currentUser?.email;

  Stream<FirebaseAuthUser?> get authStateChanges => _authState.stream;

  Future<FirebaseAuthCredential> signUp({
    required String email,
    required String password,
  }) async {
    final user = FirebaseAuthUser(
      uid: email.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_'),
      email: email.trim(),
    );
    _currentUser = user;
    _authState.add(user);
    return FirebaseAuthCredential(user: user);
  }

  Future<FirebaseAuthCredential> signIn({
    required String email,
    required String password,
  }) async {
    return signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    _currentUser = null;
    _authState.add(null);
  }

  Future<void> resetPassword(String email) async {}

  Future<void> updatePassword(String newPassword) async {}

  Future<void> deleteAccount() async {
    await signOut();
  }

  bool get isLoggedIn => _currentUser != null;
}
