
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netfusion/firebase_auth/utilities.dart';
import 'package:permission_handler/permission_handler.dart';

import 'homepage.dart';
class Signup2 extends StatefulWidget {
  const Signup2({super.key});
  @override
  State<Signup2> createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> {
  File? imageUrl;
  showImage() async{
    final _imagePicker = ImagePicker();
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageUrl = File(image!.path);
    });
  }

  uploadImage() async {
    if (imageUrl == null) {
      return;
    }
    var userdata = MyUser().getCurrentUser();
    final _firebaseStorage = FirebaseStorage.instanceFor(
        bucket: "gs://net-fusion-16728.appspot.com");
    if (imageUrl != null) {
      //Upload to Firebase
      var snapshot = await _firebaseStorage.ref()
          .child('images/${userdata.uid}')
          .putFile(imageUrl!);

      var downloadUrl = await snapshot.ref.getDownloadURL();
      print(downloadUrl);
      await FirebaseFirestore.instance.collection("users")
          .doc(userdata.uid)
          .update(
          {
            "profilepic": downloadUrl
          });
      _showPopupDialog("Profile picture added");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    }
  else{
    print("No image received");
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
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text("Net Fusion",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text("Welcome!",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.green),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30,bottom: 30),
              child: Text("Add profile picture",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.green),),
            ),
            if(imageUrl!=null)
              Stack(
                children: [
                  Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: Image.file(
                    imageUrl!,
                    fit: BoxFit.fill,
                  ),
                ),
              ]),
            SizedBox(height: 30,),
            Container(
              width: 180,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50)),
              child: GestureDetector
                (
                onTap: showImage ,
                  child: Center(child: Text("Add a profile Picture"))),
            ),
           SizedBox(height: 30,),
            if(imageUrl!=null)
            Container(
              width: 180,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50)),
              child: GestureDetector
                (
                  onTap: uploadImage ,
                  child: Center(child: Text("Upload profile picture"))),
            ),
          ],
        ),
      ),
    );
  }
  void _showPopupDialog(String info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Message"),
          content: Text(info),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

