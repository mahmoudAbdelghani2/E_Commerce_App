import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/models/person_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<void> signUp({
    required String name,
    required String email,
    required String username,
    required String password,
    String? gender,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user == null) throw Exception("User creation failed");

    await user.updateDisplayName(name);

    await user.reload();
    final currentUser = FirebaseAuth.instance.currentUser ?? user;
    final resolvedName = currentUser.displayName ?? name;

    final person = PersonModel(
      id: user.uid,
      name: resolvedName,
      email: email,
      username: username,
      gender: gender,
    );

    await _firestore.collection('users').doc(user.uid).set(person.toMap());
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }

  Future<PersonModel> getOrCreateUser(User user, {String? gender, String? preferredUsername}) async {
    final ref = _firestore.collection('users').doc(user.uid);
    final doc = await ref.get();

    if (doc.exists && doc.data() != null) {
      return PersonModel.fromMap(doc.data()!);
    }

    final name = user.displayName ?? user.email?.split('@')[0] ?? "User";
    final username = preferredUsername ?? name.toLowerCase().replaceAll(" ", "_");
    final person = PersonModel(
      id: user.uid,
      name: name,
      email: user.email ?? "",
      username: username,
      gender: gender,
    );

    await ref.set(person.toMap());
    return person;
  }
}
