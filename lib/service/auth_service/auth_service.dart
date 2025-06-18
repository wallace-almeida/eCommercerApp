import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // instance do fireStore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signup({
    required String name,
    required String email,
    required String senha,
    required String role,
  }) async {
    try {
      // criar User no firebase, com autenticacao email e senha
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: senha.trim(),
          );

      // save user in firestore (nome, email, role,)
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "name": name.trim(),
        "role": role,
        "email": email.trim(),
      });

      return null; // sucesso, sem erro
    } catch (e) {
      return e.toString();
    }
  }

  // login

  Future<String?> login({required String email, required String senha}) async {
    try {
      // logar o User usando o firebase, com autenticacao email e senha
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha.trim(),
      );

      // fetching the user s  role from firestore to determinde acess level
      DocumentSnapshot userDoc =
          await _firestore
              .collection("users")
              .doc(userCredential.user!.uid)
              .get();

      return userDoc["role"]; // return role, adim or users
    } catch (e) {
      return e.toString();
    }
  }

  //Logout do usuario

  signOut() async {
    _auth.signOut();
  }
}
