import 'package:e_commerce_app/controllers/auth/auth_states.dart';
import 'package:e_commerce_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial()) {
    _authService.user.listen((user) async {
      if (user != null) {
        await _loadUser(user);
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<void> _loadUser(User user, {String? gender, String? preferredUsername}) async {
    if (state is Authenticated && (state as Authenticated).user.id == user.uid) {
      return; 
    }

    emit(AuthLoading());
    try {
  final person = await _authService.getOrCreateUser(user, gender: gender, preferredUsername: preferredUsername);
      emit(Authenticated(person));
    } catch (e) {
      emit(AuthError("Error loading user: $e"));
    }
  }

  Future<void> signUp(
      String name,
      String email,
      String username,
      String password, {
      String? gender,
    }) async {
    emit(AuthLoading());
    try {
      await _authService.signUp(
        name: name,
        email: email,
        username: username,
        password: password,
        gender: gender,
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
  await _loadUser(user, gender: gender, preferredUsername: username);
      } else {
        emit(AuthError("Sign up failed"));
      }
    } catch (e) {
      emit(AuthError("Sign up error: $e"));
    }
  }

  Future<void> logIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authService.logIn(email: email, password: password);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _loadUser(user);
      } else {
        emit(AuthError("Login failed"));
      }
    } catch (e) {
      emit(AuthError("Login error: $e"));
    }
  }

  Future<void> logOut() async {
    try {
      await _authService.logOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError("Logout error: $e"));
    }
  }

  Future<void> reloadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _loadUser(user);
    } else {
      emit(Unauthenticated());
    }
  }
}
