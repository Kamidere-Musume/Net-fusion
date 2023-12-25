import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netfusion/firebase_auth/utilities.dart';
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
            "upload_date":FieldValue.serverTimestamp()
          });
     /* setState(() {
        imageUrl = downloadUrl;
      });*/
    }
    else {
      print('No Image Path Received');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
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
                  child: Text("Upload")),
            ),
            Container(
              width: 220,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50)),
              child: GestureDetector
                (
                  onTap: ()async{
                    await showImage();
                  },
                  child: Text("Select Image")),
            ),
            FormContainerWidget(
              hintText: "Caption",
              controller: _captionController,
            ),
            if (imageUrl != null)
              Expanded(
                child : Container(
                  width: 300,
                  height: 10,
                  child: Image.file(
                    imageUrl!,
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}

