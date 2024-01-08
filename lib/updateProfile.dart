import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netfusion/profile.dart';
import 'package:netfusion/upload.dart';
import 'package:netfusion/widgets/form_container_widget.dart';

import 'firebase_auth/utilities.dart';
import 'homepage.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}
class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController _updateusername = TextEditingController();
    File? imageUrl;
    showImage() async {
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
        _showPopupDialog("Profile picture updated");
      }
      else {
       _showPopupDialog("Error updating profile picture");
      }
    }

  updateUsername() async {
    var userdata = MyUser().getCurrentUser();
    await FirebaseFirestore.instance.collection("users")
        .doc(userdata.uid)
        .update(
        {
          "username": _updateusername.text
        });
    _showPopupDialog("Username Updated");
    _updateusername.clear();
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
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Column(
            children: [
              Image.asset("assets/images/line4.png"),
              Image.asset("assets/images/line3.png"),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("Net Fusion",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: Text("Update Profile", style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),),
              ),

              if(imageUrl == null)
                Container(
                  height: 200,
                  child: Stack(
                    children: [
                      Container(
                        child: FutureBuilder<String?>(
                          future: getProfilePicture(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              return Positioned(
                                top: 20,
                                left: 120,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.green, // Set the border color
                                      width: 3, // Set the border width
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: ClipOval(
                                      child: Image.network(
                                        snapshot.data!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Text('No profile picture available');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              if(imageUrl != null)
                Stack(
                    children: [
                      Positioned(
                        top: 500,
                        left: 250,
                        child: Container(
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
                      ),
                    ]),
              SizedBox(height: 30,),
              Container(
                width: 230,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50)),
                child: GestureDetector
                  (
                    onTap: showImage,
                    child: Center(child: Text("Add a profile Picture",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),))),
              ),
              SizedBox(height: 30,),
              if(imageUrl != null)
                Container(
                  width: 230,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(50)),
                  child: GestureDetector
                    (
                      onTap: uploadImage,
                      child: Center(child: Text("Upload profile picture",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),))),
                ),
              SizedBox(height: 60,),
              Container(
                width: 300,
                child: Column(
                  children: [
                    FormContainerWidget(
                      hintText: "Update Username",
                      controller: _updateusername,
                    ),
                    SizedBox(height: 30,),
                    Container(
                      width: 230,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50)),
                      child: GestureDetector(
                        onTap: updateUsername,
                      child: Center(child: Text("Update Username",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 55,
          color: Colors.transparent,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.home,size: 30,weight: 20,color: Colors.white,),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add,size: 30,weight: 20,color: Colors.white,),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadPage()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person,size: 30,weight: 20,color: Colors.white,),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>Profile()),
                    );
                  },
                ),
              ],
            ),
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
