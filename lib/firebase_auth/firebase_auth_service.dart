import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService{
  FirebaseAuth _auth =  FirebaseAuth.instance;

  Future<User?>signup(String email, String password,String firstname, String lastname, String number, String username)async{
    print(_auth);
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // Create a new user with a first and last name
      FirebaseFirestore.instance.collection("users").doc(credential.user?.uid).set({
        "firstname":firstname,
        "lastname":lastname,
        "number":number,
        "username":username
      }).then((value) => print("nigaas"));
      return credential.user;
    }
    catch(e){
      print(e);
    }
    return null;
  }
  Future<User?>signin(String email, String password)async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }
    catch(e){
      print("Error");
    }
    return null;
  }
}
