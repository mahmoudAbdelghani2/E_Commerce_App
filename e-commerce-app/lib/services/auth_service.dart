import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/models/person_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Keys for SharedPreferences
  static const String _rememberMeKey = 'remember_me';
  static const String _emailKey = 'user_email';
  static const String _passwordKey = 'user_password';

  Stream<User?> get user => _auth.authStateChanges();

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    String? gender,
  }) async {
  try {
      
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = userCredential.user;

      if (user != null) {
        
        
        PersonModel person = PersonModel(
          id: user.uid,
          name: name,
          email: email,
          username: email.split('@')[0], 
          gender: gender,
        );
        await user.updateDisplayName(name);
        
  Map<String, dynamic> userData = person.toMap();
        
        try {
          await _firestore.collection('users').doc(user.uid).set(userData);
          
          DocumentSnapshot docCheck = await _firestore.collection('users').doc(user.uid).get();
          if (!docCheck.exists) {
            await _firestore.collection('users').doc(user.uid).set(userData);
            
            docCheck = await _firestore.collection('users').doc(user.uid).get();
            if (!docCheck.exists) {
              throw "Failed to save user data to database after multiple attempts";
            }
          }
        } catch (firestoreError) {
          
          
          try {
            await user.delete();
          } catch (deleteError) {}
          
          throw "Failed to create user account: $firestoreError";
        }
      } else {
        throw "Failed to create user - user ID was not received";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logIn({
    required String email, 
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      
      try {
        // Try to sign in
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
        );
        
        
        
        // Verify user is actually logged in
        if (userCredential.user == null) {
          throw "Login failed - unable to authenticate";
        }
        
        // Save credentials if rememberMe is true
        if (rememberMe) {
          
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(_rememberMeKey, true);
          await prefs.setString(_emailKey, email);
          await prefs.setString(_passwordKey, password);
        } else {
          // Clear saved credentials if rememberMe is false
          
          await clearSavedCredentials();
        }
        
        // Verify that Firebase Auth state has been updated
        
      } catch (e) {
        // Handle specific Firebase Auth errors
  if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'user-not-found':
              throw 'Email not found. Please check your email or sign up first.';
            case 'wrong-password':
              throw 'Incorrect password. Please try again.';
            case 'invalid-credential':
              throw 'Invalid login information. Please check email and password.';
            case 'user-disabled':
              throw 'This account has been disabled. Please contact support.';
            default:
              throw 'Login failed: ${e.message}';
          }
        }
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberMeKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_passwordKey);
  }
  
  Future<Map<String, dynamic>?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    
    if (rememberMe) {
      final email = prefs.getString(_emailKey);
      final password = prefs.getString(_passwordKey);
      
      if (email != null && password != null) {
        return {
          'email': email,
          'password': password,
        };
      }
    }
    
    return null;
  }

  Future<PersonModel?> getUserData(String uid) async {
    try {
      
      
      // Add multiple attempts to get user data
      int maxRetries = 3;
      int retryCount = 0;
      Exception? lastError;
      
      while (retryCount < maxRetries) {
        try {
          // الحصول على وثيقة المستخدم من Firestore
          DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
          
          
          if (doc.exists && doc.data() != null) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            
            
            // التأكد من أن البيانات الأساسية موجودة
            if (!data.containsKey('name') || !data.containsKey('email')) {
              
              
              // تحديث البيانات الناقصة من حساب Firebase Auth
              User? authUser = _auth.currentUser;
              if (authUser != null && authUser.uid == uid) {
                String email = authUser.email ?? data['email'] ?? "";
                String name = authUser.displayName ?? data['name'] ?? email.split('@')[0];
                
                data['name'] = name;
                data['email'] = email;
                if (!data.containsKey('username')) {
                  data['username'] = name.toLowerCase().replaceAll(" ", "_");
                }
                
                // تحديث الوثيقة في Firestore
                await _firestore.collection('users').doc(uid).update(data);
                
              }
            }
            
            // إنشاء نموذج المستخدم من البيانات
            PersonModel user = PersonModel.fromMap(data);
            
            return user;
          } else {
            // إذا كانت الوثيقة غير موجودة في Firestore ولكن المستخدم مصادق عليه،
            // يمكننا محاولة إنشاء ملف تعريف مستخدم باستخدام بيانات Firebase Auth
            User? authUser = _auth.currentUser;
            if (authUser != null && authUser.uid == uid) {
              
              
              // جلب البريد الإلكتروني للمستخدم من Firebase Auth
              String email = authUser.email ?? "";
              String name = authUser.displayName ?? email.split('@')[0];
              String username = name.toLowerCase().replaceAll(" ", "_");
              
              final person = PersonModel(
                id: authUser.uid,
                name: name,
                email: email,
                username: username,
              );
              
              // محاولة حفظ البيانات في Firestore
              
              await _firestore.collection('users').doc(uid).set(person.toMap());
              
              
              // تحقق من أن البيانات تم حفظها بنجاح
              DocumentSnapshot verifyDoc = await _firestore.collection('users').doc(uid).get();
              if (!verifyDoc.exists) {
                
                throw Exception("Document wasn't saved properly");
              }
              
              return person;
            }
            
            if (retryCount == maxRetries - 1) {
              
              return null;
            }
          }
        } catch (e) {
          lastError = e as Exception;
          
          await Future.delayed(Duration(milliseconds: 1000));
        }
        
        retryCount++;
      }
      
      if (lastError != null) {
        throw lastError;
      }
      
      return null;
    } catch (e) {
      
      rethrow;
    }
  }
  
  Future<void> saveUserData(PersonModel person) async {
    try {
  await _firestore.collection('users').doc(person.id).set(person.toMap());
    } catch (e) {
      
      rethrow;
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
    await clearSavedCredentials();
  }
}
