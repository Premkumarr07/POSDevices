import '../../core/services/auth_service.dart';

class AuthRepository {
  AuthRepository({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  Future<void> login(String email, String password) async {
    await _authService.login(email, password);
  }

  Future<void> logout() => _authService.logout();
}
