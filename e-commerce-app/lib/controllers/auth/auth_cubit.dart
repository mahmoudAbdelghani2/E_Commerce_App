import 'package:e_commerce_app/controllers/auth/auth_states.dart';
import 'package:e_commerce_app/services/auth_service.dart';
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
    try {
      final person = await _authService.getUserData(uid);
      if (person != null) {
        emit(Authenticated(person));
      } else {
        // This case might happen if the user is in auth but not in firestore.
        // You might want to handle this more gracefully.
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      await _authService.signUp(name: name, email: email, password: password);
      // The stream listener will handle emitting the Authenticated state
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authService.logIn(email: email, password: password);
      // The stream listener will handle emitting the Authenticated state
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logOut() async {
    try {
      await _authService.logOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
