import 'package:e_commerce_app/controllers/auth/auth_states.dart';
import 'package:e_commerce_app/models/adress_model.dart';
import 'package:e_commerce_app/models/person_model.dart';
import 'package:e_commerce_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  AuthCubit(this._authService) : super(AuthInitial()) {
    print("AuthCubit initialized");
    
    // Set up auth state listener
    _authService.user.listen((user) {
      print("Firebase Auth state changed: user is ${user != null ? 'logged in' : 'logged out'}");
      if (user != null) {
        print("Auth state change detected for user: ${user.uid}, email: ${user.email}");
        _loadUserData(user.uid);
      } else {
        print("User logged out or auth state reset");
        emit(Unauthenticated());
        print("Emitted Unauthenticated state");
      }
    });
  }

  Future<void> _loadUserData(String uid) async {
    print("Loading user data for UID: $uid");
    emit(AuthLoading());
    print("Emitted AuthLoading state");
    
    // Maximum retry attempts
    int maxRetries = 3;
    int retryCount = 0;
    
    while (retryCount < maxRetries) {
      try {
        final authUser = FirebaseAuth.instance.currentUser;
        if (authUser == null || authUser.uid != uid) {
          print("User not found in Firebase Auth or UID mismatch");
          emit(Unauthenticated());
          return;
        }
        
        final person = await _authService.getUserData(uid);
        
        if (person != null) {
          print("User data loaded successfully: ${person.name}, ${person.email}");
          emit(Authenticated(person));
          print("Emitted Authenticated state");
          return;
        } else {
          if (retryCount == maxRetries - 1) {
            print("Last retry attempt, creating basic user profile from Auth data");
            
            if (authUser.email != null) {
              final String name = authUser.displayName ?? authUser.email!.split('@')[0];
              final person = PersonModel(
                id: authUser.uid,
                name: name,
                email: authUser.email!,
                username: name.toLowerCase().replaceAll(" ", "_"),
              );
              
              try {
                print("Saving basic user profile to Firestore: ${person.toMap()}");
                await _authService.saveUserData(person);
                
                final savedPerson = await _authService.getUserData(uid);
                if (savedPerson != null) {
                  emit(Authenticated(savedPerson));
                  print("Created and emitted basic user profile");
                  return;
                } else {
                  throw Exception("Data was saved but could not be retrieved");
                }
              } catch (e) {
                print("Failed to save basic profile: $e");
                emit(AuthError("Failed to save user data: $e"));
                return;
              }
            }
            
            print("User exists in Auth but not in Firestore after all retries");
            emit(AuthError("Logged in but failed to retrieve user data"));
          } else {
            print("Attempt ${retryCount + 1} failed, retrying...");
            await Future.delayed(Duration(milliseconds: 1000));
            retryCount++;
          }
        }
      } catch (e) {
        print("Error loading user data (attempt ${retryCount + 1}): $e");
        if (retryCount == maxRetries - 1) {
          emit(AuthError("Error loading user data: $e"));
          print("Emitted AuthError state after all retries failed");
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
      print("SignUp process started for email: $email with gender: $gender");
      
      await _authService.signUp(
        name: name, 
        email: email, 
        password: password,
        gender: gender
      );
      
      final user = FirebaseAuth.instance.currentUser;
      print("Current user after signup: ${user?.uid ?? 'null'}");
      
      if (user != null) {
        await Future.delayed(Duration(milliseconds: 1000));
        
        print("Verifying user data in Firestore");
        final userData = await _authService.getUserData(user.uid);
        
        if (userData == null) {
          print("User data not found in Firestore, creating it now");
          
          final person = PersonModel(
            id: user.uid,
            name: name,
            email: email,
            username: email.split('@')[0],
            gender: gender,
          );
          await _authService.saveUserData(person);
          print("User data created and saved manually");
          
          emit(Authenticated(person));
        } else {
          print("User data found in Firestore: ${userData.name}");
          emit(Authenticated(userData));
        }
      } else {
        print("ERROR: User is null after signup");
        emit(AuthError("Registration failed - please try again"));
      }
    } catch (e) {
      print("Error during signup: $e");
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logIn(String email, String password, {bool rememberMe = false}) async {
    emit(AuthLoading());
    try {
      print("Attempting login with email: $email");
      await _authService.logIn(
        email: email, 
        password: password,
        rememberMe: rememberMe
      );
      
      await Future.delayed(Duration(milliseconds: 800));
      
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print("Login successful, user ID: ${user.uid}, email: ${user.email}");
        
        try {
          var userData = await _authService.getUserData(user.uid);
          
          if (userData == null) {
            print("NOTICE: No user data found in Firestore after login. Creating basic profile...");
            
            userData = PersonModel(
              id: user.uid,
              name: user.displayName ?? email.split('@')[0],
              email: email,
              username: email.split('@')[0],
            );
            
            await _authService.saveUserData(userData);
            print("Created and saved basic user profile for: ${userData.name}");
          }
          emit(Authenticated(userData));
          print("Emitted Authenticated state with user data: ${userData.name}");
        } catch (dataError) {
          print("Error loading/saving user data after login: $dataError");
          emit(AuthError("Login successful but failed to load user data: $dataError"));
        }
      } else {
        print("Login failed - currentUser is null after login attempt");
        emit(AuthError("Login failed - please try again"));
      }
    } catch (e) {
      print("Login error: ${e.toString()}");
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
  
  // Update user addresses
  Future<void> updateUserAddresses(List<AddressModel> addresses) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(AuthError("No authenticated user found"));
        return;
      }
      
      emit(AuthLoading());
      print("Updating user addresses");
      
      // Get current user data
      final currentState = state;
      if (currentState is Authenticated) {
        // Create updated user model with new addresses
        final updatedUser = PersonModel(
          id: currentState.user.id,
          name: currentState.user.name,
          email: currentState.user.email,
          username: currentState.user.username,
          gender: currentState.user.gender,
          age: currentState.user.age,
          phoneNumber: currentState.user.phoneNumber,
          imageUrl: currentState.user.imageUrl,
          addresses: addresses,
        );
        
        // Save to Firestore
        await _authService.saveUserData(updatedUser);
        
        // Update state
        emit(Authenticated(updatedUser));
        print("User addresses updated successfully");
      } else {
        throw Exception("Cannot update addresses: user not authenticated");
      }
    } catch (e) {
      print("Error updating user addresses: $e");
      emit(AuthError(e.toString()));
    }
  }
  
  // Public method to manually reload current user data
  Future<void> reloadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emit(AuthLoading());
      print("Manually reloading user data");
      await _loadUserData(user.uid);
    } else {
      emit(Unauthenticated());
    }
  }
}
