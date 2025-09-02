import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/models/person_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user;
    if (user == null) throw Exception('Failed to create user');

    await user.updateDisplayName(name);

    final person = PersonModel(
      id: user.uid,
      name: name,
      email: email,
      username: email.split('@')[0],
      gender: gender,
    );

    await _firestore.collection('users').doc(user.uid).set(person.toMap());
  }

  Future<void> logIn({required String email, required String password, bool rememberMe = false}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (rememberMe) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberMeKey, true);
      await prefs.setString(_emailKey, email);
      await prefs.setString(_passwordKey, password);
    } else {
      await clearSavedCredentials();
    }
  }

  Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberMeKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_passwordKey);
  }

  Future<Map<String, String>?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    if (!rememberMe) return null;
    final email = prefs.getString(_emailKey);
    final password = prefs.getString(_passwordKey);
    if (email != null && password != null) return {'email': email, 'password': password};
    return null;
  }

  Future<PersonModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
  return PersonModel.fromMap(doc.data()!);
  }

  Future<void> saveUserData(PersonModel person) async {
    await _firestore.collection('users').doc(person.id).set(person.toMap());
  }

  Future<void> logOut() async {
    await _auth.signOut();
    await clearSavedCredentials();
  }
}
