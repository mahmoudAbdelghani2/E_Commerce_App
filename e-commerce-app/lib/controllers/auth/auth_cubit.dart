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
    
    int maxRetries = 3;
    int retryCount = 0;
    
    while (retryCount < maxRetries) {
      try {
        final authUser = FirebaseAuth.instance.currentUser;
        if (authUser == null || authUser.uid != uid) {
          emit(Unauthenticated());
          return;
        }
        
        final person = await _authService.getUserData(uid);
        
        if (person != null) {
          emit(Authenticated(person));
          return;
        } else {
          if (retryCount == maxRetries - 1) {
            
            if (authUser.email != null) {
              final String name = authUser.displayName ?? authUser.email!.split('@')[0];
              final person = PersonModel(
                id: authUser.uid,
                name: name,
                email: authUser.email!,
                username: name.toLowerCase().replaceAll(" ", "_"),
              );
              
              try {
                await _authService.saveUserData(person);
                
                final savedPerson = await _authService.getUserData(uid);
                if (savedPerson != null) {
                  emit(Authenticated(savedPerson));
                  return;
                } else {
                  throw Exception("Data was saved but could not be retrieved");
                }
              } catch (e) {
                emit(AuthError("Failed to save user data: $e"));
                return;
              }
            }
            
            emit(AuthError("Logged in but failed to retrieve user data"));
          } else {
            await Future.delayed(Duration(milliseconds: 1000));
            retryCount++;
          }
        }
      } catch (e) {
        if (retryCount == maxRetries - 1) {
          emit(AuthError("Error loading user data: $e"));
        } else {
          await Future.delayed(Duration(milliseconds: 1000));
          retryCount++;
        }
      }
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    return signUpWithGender(name, email, password, gender: null);
  }
  
  Future<void> signUpWithGender(String name, String email, String password, {String? gender}) async {
    emit(AuthLoading());
    try {
      
      await _authService.signUp(
        name: name, 
        email: email, 
        password: password,
        gender: gender
      );
      
      final user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {
        await Future.delayed(Duration(milliseconds: 1000));
        
        final userData = await _authService.getUserData(user.uid);
        
        if (userData == null) {
          
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
          emit(Authenticated(userData));
        }
      } else {
        emit(AuthError("Registration failed - please try again"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logIn(String email, String password, {bool rememberMe = false}) async {
    emit(AuthLoading());
    try {
      await _authService.logIn(
        email: email, 
        password: password,
        rememberMe: rememberMe
      );
      
      await Future.delayed(Duration(milliseconds: 800));
      
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        
        try {
          var userData = await _authService.getUserData(user.uid);
          
          if (userData == null) {
            
            userData = PersonModel(
              id: user.uid,
              name: user.displayName ?? email.split('@')[0],
              email: email,
              username: email.split('@')[0],
            );
            
            await _authService.saveUserData(userData);
          }
          emit(Authenticated(userData));
        } catch (dataError) {
          emit(AuthError("Login successful but failed to load user data: $dataError"));
        }
      } else {
        emit(AuthError("Login failed - please try again"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  
  Future<void> checkSavedCredentials() async {
    try {
      final savedCredentials = await _authService.getSavedCredentials();
      if (savedCredentials != null) {
        await logIn(
          savedCredentials['email'], 
          savedCredentials['password'],
          rememberMe: true
        );
      }
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
  
  Future<void> reloadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emit(AuthLoading());
      await _loadUserData(user.uid);
    } else {
      emit(Unauthenticated());
    }
  }
}
