import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// SignUp: name + username + email + password (+ age, phone)
  Future<String> signUpWithUsernameEmail({
    required String name,
    required String username,
    required String email,
    required String password,
    int? age,
    String? phoneNumber,
  }) async {
    // 1) تأكد إن اليوزرنيم مش محجوز
    final unameDoc = await _firestore.collection('usernames').doc(username).get();
    if (unameDoc.exists) {
      throw Exception('USERNAME_TAKEN');
    }

    // 2) أنشئ حساب بالميل والباسورد
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;

    // 3) خزن بيانات المستخدم في users/{uid} (بدون كلمة السر)
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'age': age,
      'phoneNumber': phoneNumber,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 4) احفظ ماب اليوزرنيم → ايميل/يوزر
    await _firestore.collection('usernames').doc(username).set({
      'uid': uid,
      'email': email,
    });

    // (اختياري) حدّث displayName
    await cred.user!.updateDisplayName(name);

    return uid;
  }

  /// SignIn: username + password
  Future<String> signInWithUsername(String username, String password) async {
    // هات الايميل من كولكشن usernames
    final mapping = await _firestore.collection('usernames').doc(username).get();
    if (!mapping.exists) {
      throw Exception('USER_NOT_FOUND');
    }
    final email = mapping.data()!['email'] as String;

    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user!.uid;
  }

  Future<void> signOut() => _auth.signOut();
}
