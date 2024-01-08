import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netfusion/firebase_auth/utilities.dart';
import 'package:netfusion/homepage.dart';
import 'package:netfusion/profile.dart';
import 'package:netfusion/widgets/form_container_widget.dart';
import 'package:permission_handler/permission_handler.dart';
class UploadPage extends StatefulWidget {
  const UploadPage({super.key});
  @override
  State<UploadPage> createState() => _UploadPageState();
}
class _UploadPageState extends State<UploadPage> {
  TextEditingController _captionController = TextEditingController();
  File? imageUrl;
    showImage() async{
    final _imagePicker = ImagePicker();
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageUrl = File(image!.path);
    });
  }

  uploadImage() async {
      if(imageUrl== null){
        return;
      }
    var userdata = MyUser().getCurrentUser();
    final _firebaseStorage = FirebaseStorage.instanceFor(bucket: "gs://net-fusion-16728.appspot.com");
    var imagehash = hashimage(imageUrl!.path);
    String replacedString = imagehash.replaceAll('/', 'slash');
    if (imageUrl != null){
      //Upload to Firebase
      var snapshot = await _firebaseStorage.ref()
          .child('upload/${userdata.uid}/"$replacedString"')
          .putFile(imageUrl!);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      print(downloadUrl);
      await FirebaseFirestore.instance.collection("posts").doc(userdata.uid + replacedString).set(
          {
            "userid": userdata.uid,
            "imageurl": downloadUrl,
            "caption":_captionController.text,
            "upload_date":FieldValue.serverTimestamp(),
            "username": userdata.username
          });
      _showPopupDialog("Post has been added");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    }
    else {
      _showPopupDialog("Unable to add post");
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Column(
            children: [
              SizedBox(height: 80,),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_ios,color: Colors.white,),
                    SizedBox(width: 50,),
                    Text('Create Post',style: TextStyle(
                      color: Colors.green,
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
              ),
              SizedBox(height: 30,),
              FormContainerWidget(
                hintText: "Caption",
                controller: _captionController,
              ),
              SizedBox(height: 50,),
              if (imageUrl != null)
                  Container(
                    width: 300,
                    height: 300,
                    child: Image.file(
                      imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
              if(imageUrl == null)
                 Container(
                  width: 250,
                  height: 300,
                  child:   Image.asset("assets/images/upload.png"),
                ),
              SizedBox(height: 40,),
              Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50)),
                child: GestureDetector
                  (
                    onTap: ()async{
                      await showImage();
                    },
                    child: Center(child: Text("Select Image",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),))),
              ),
              SizedBox(height: 30,),
              if(imageUrl!=null)
              Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50)),
                child: GestureDetector
                  (
                    onTap: uploadImage,
                    child: Center(child: Text("Upload",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)))),
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

