import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

class MyUser {
  String username="";
  String email="";
  String uid="";
  bool user_exist = false;
  String number = "";
  String firstname = "";
  String lastname = "";
  String profilepic = "";
  late User _authUser;
  // Method to print user information
  MyUser getCurrentUser() {
    if(!user_exist){
      _retrieveUser();
    }
    return this;
  }
  void _retrieveUser() async{
    var authUser =  FirebaseAuth.instance.currentUser;
    if(authUser == null){
      return;
    }
    this._authUser = authUser;
    this.email = authUser.email!;
    this.uid = authUser.uid;

    final docRef = FirebaseFirestore.instance.collection("users").doc(authUser.uid);
    docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        user_exist = true;
        this.number = data["number"];
        this.username = data["username"];
        this.firstname = data["firstname"];
        this.lastname = data["lastname"];
        this.profilepic = data["profilepic"];
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }
}

String hashimage(String imagePath) {
  try {
    List<int> imageBytes = File(imagePath).readAsBytesSync();
    String hash = hashBytes(imageBytes);

    print('Image Hash: $hash');
    return hash;
  } catch (e) {
    print('Error reading or hashing the image: $e');
  }
  return "";
}

String hashBytes(List<int> bytes) {
  Digest digest = sha256.convert(bytes);
  return base64Encode(digest.bytes);
}

Future<List<Map<String, dynamic>>> retrievePost()async{
 var post = await FirebaseFirestore.instance.collection("posts").orderBy("upload_date",descending: true).get();
 final allData = post.docs.map((doc) => doc.data()).toList();
 return allData;
}

Future<String?> getProfilePicture() async {
  var userdata = MyUser().getCurrentUser();
  DocumentSnapshot doc =
  await FirebaseFirestore.instance.collection("users").doc(userdata.uid).get();

  if (doc.exists) {
    final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data != null && data['profilepic'] != null) {
      return data['profilepic'];
    }
  }
  return null;
}