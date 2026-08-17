import 'dart:async';

class LocalAuthUser {
  LocalAuthUser({required this.uid, required this.email});

  final String uid;
  final String email;
}

class LocalAuthCredential {
  LocalAuthCredential({required this.user});

  final LocalAuthUser user;
}

class AuthService {
  AuthService();

  final StreamController<LocalAuthUser?> _authState =
      StreamController<LocalAuthUser?>.broadcast();

  LocalAuthUser? _currentUser;

  LocalAuthUser? get currentUser => _currentUser;

  Stream<LocalAuthUser?> get authStateChanges => _authState.stream;

  Future<LocalAuthCredential> login(String email, String password) async {
    final user = LocalAuthUser(
      uid: email.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_'),
      email: email.trim(),
    );
    _currentUser = user;
    _authState.add(user);
    return LocalAuthCredential(user: user);
  }

  Future<void> logout() async {
    _currentUser = null;
    _authState.add(null);
  }

  void dispose() {
    _authState.close();
  }
}
