import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
ValueNotifier<Authservice> authservice = ValueNotifier(Authservice());
class Authservice {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => firebaseAuth.currentUser;
  Stream<User?> get authStateChanges=> firebaseAuth.authStateChanges();
  Future<void> register({
    required String email,
    required String password,
  }) async {
    try{
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } 
    catch(e){
            print(e);
    }
  }
    Future<void> login({
    required String email,
    required String password,
  }) async {
    try{
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } 
    catch(e){
            print(e);
    }
  }
  Future<void>  logout() async
    {
       await firebaseAuth.signOut();
    }
}