
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netfusion/firebase_auth/utilities.dart';
import 'package:permission_handler/permission_handler.dart';
class Signup2 extends StatefulWidget {
  const Signup2({super.key});
  @override
  State<Signup2> createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> {
  String? imageUrl = "https://images.unsplash.com/photo-1575936123452-b67c3203c357?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
  uploadImage() async {
   var userdata = MyUser().getCurrentUser();
    final _firebaseStorage = FirebaseStorage.instanceFor(bucket: "gs://net-fusion-16728.appspot.com");
    final _imagePicker = ImagePicker();
      //Select Image
      XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      var file = File(image!.path);

      if (image != null){
        //Upload to Firebase
        var snapshot = await _firebaseStorage.ref()
            .child('images/${userdata.uid}')
            .putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();
        print(downloadUrl);
        await FirebaseFirestore.instance.collection("users").doc(userdata.uid).update(
            {
              "profilepic": downloadUrl
            });
        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Image Path Received');
      }
    }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Image.asset("assets/images/line4.png"),
            Image.asset("assets/images/line3.png"),
            Image.asset("assets/images/line2.png"),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text("Net Fusion",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            ),
            Container(
              width: 220,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50)),
              child: GestureDetector
                (
                onTap: uploadImage,
                  child: Text("Hello")),
            ),
            Image.network(imageUrl!),
          ],
        ),
      ),
    );
  }
}

