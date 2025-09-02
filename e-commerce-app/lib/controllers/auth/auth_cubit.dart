import 'package:e_commerce_app/controllers/auth/auth_states.dart';
import 'package:e_commerce_app/models/person_model.dart';
import 'package:e_commerce_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial()) {
    _authService.user.listen((user) {
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<void> _loadUserData(String uid) async {
    emit(AuthLoading());
    try {
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null || authUser.uid != uid) {
        emit(Unauthenticated());
        return;
      }

      final person = await _authService.getUserData(uid);

      if (person != null) {
        emit(Authenticated(person));
      } else {
        final name =
            authUser.displayName ?? authUser.email?.split('@')[0] ?? "User";
        final newPerson = PersonModel(
          id: authUser.uid,
          name: name,
          email: authUser.email ?? "",
          username: name.toLowerCase().replaceAll(" ", "_"),
        );

        await _authService.saveUserData(newPerson);
        emit(Authenticated(newPerson));
      }
    } catch (e) {
      emit(AuthError("Error loading user data: $e"));
    }
  }

  Future<void> signUp(
    String name,
    String email,
    String password, {
    String? gender,
  }) async {
    emit(AuthLoading());
    try {
      await _authService.signUp(
        name: name,
        email: email,
        password: password,
        gender: gender,
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final person = PersonModel(
          id: user.uid,
          name: name,
          email: email,
          username: email.split('@')[0],
          gender: gender,
        );
        await _authService.saveUserData(person);
        emit(Authenticated(person));
      } else {
        emit(AuthError("Registration failed - please try again"));
      }
    } catch (e) {
      emit(AuthError("Sign up failed: $e"));
    }
  }

  Future<void> logIn(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    emit(AuthLoading());
    try {
      await _authService.logIn(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var person = await _authService.getUserData(user.uid);
        if (person == null) {
          // لو أول مرة يدخل
          person = PersonModel(
            id: user.uid,
            name: user.displayName ?? email.split('@')[0],
            email: email,
            username: email.split('@')[0],
          );
          await _authService.saveUserData(person);
        }
        emit(Authenticated(person));
      } else {
        emit(AuthError("Login failed - please try again"));
      }
    } catch (e) {
      emit(AuthError("Login error: $e"));
    }
  }

  Future<void> checkSavedCredentials() async {
    try {
      final creds = await _authService.getSavedCredentials();
      if (creds != null) {
  final email = creds['email']!;
  final password = creds['password']!;
  await logIn(email, password, rememberMe: true);
      }
    } catch (e) {
      emit(AuthError("Error checking saved credentials: $e"));
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
      await _loadUserData(user.uid);
    } else {
      emit(Unauthenticated());
    }
  }
}
