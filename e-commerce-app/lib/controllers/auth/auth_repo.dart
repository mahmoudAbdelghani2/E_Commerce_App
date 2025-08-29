import '../../services/auth_service.dart';

class AuthRepository {
  final AuthService _service;
  AuthRepository(this._service);

  Future<String> signUp({
    required String name,
    required String username,
    required String email,
    required String password,
    int? age,
    String? phoneNumber,
  }) {
    return _service.signUpWithUsernameEmail(
      name: name,
      username: username,
      email: email,
      password: password,
      age: age,
      phoneNumber: phoneNumber,
    );
  }

  Future<String> signIn({
    required String username,
    required String password,
  }) {
    return _service.signInWithUsername(username, password);
  }

  Future<void> signOut() => _service.signOut();
}
