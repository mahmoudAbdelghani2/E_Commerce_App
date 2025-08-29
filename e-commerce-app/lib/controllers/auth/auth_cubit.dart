import 'package:e_commerce_app/controllers/auth/auth_repo.dart';
import 'package:e_commerce_app/controllers/auth/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  AuthCubit(this._repository) : super(AuthInitial());

  Future<void> signUp({
    required String name,
    required String username,
    required String email,
    required String password,
    int? age,
    String? phoneNumber,
  }) async {
    emit(AuthLoading());
    try {
      final uid = await _repository.signUp(
        name: name,
        username: username,
        email: email,
        password: password,
        age: age,
        phoneNumber: phoneNumber,
      );
      emit(AuthAuthenticated(uid));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final uid = await _repository.signIn(
        username: username,
        password: password,
      );
      emit(AuthAuthenticated(uid));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _repository.signOut();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
