import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<User?> register(String email, String password, String name) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = result.user;

    await _firebaseFirestore.collection("users").doc(user!.uid).set({
      "name" : name,
      "email" : email,
      "createdAt" : DateTime.now()
    });

    return user;
  }


  Future<User?> login(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);

    return result.user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<User?> updateUserInfo({String? newName}) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (newName != null && newName.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'name': newName});
      }
      await user.reload();
      return FirebaseAuth.instance.currentUser;
    }
    return null;
  }

}