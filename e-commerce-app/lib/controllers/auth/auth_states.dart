class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String uid; // ممكن تخزن UID أو PersonModel
  AuthAuthenticated(this.uid);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthLoggedOut extends AuthState {}
