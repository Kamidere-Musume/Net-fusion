import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netfusion/login.dart';
import 'package:netfusion/signup.dart';
import 'package:netfusion/updateProfile.dart';
import 'package:netfusion/upload.dart';

import 'firebase_auth/utilities.dart';
import 'homepage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  Future<List<String>> getUserImages() async {
    var userdata = MyUser().getCurrentUser();
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
        .collection("posts")
        .doc(userdata.uid)
        .get();

    List<String> imageUrls = [];

    if (doc.exists) {
      final Map<String, dynamic>? data = doc.data();
      if (data != null && data['imageurl'] != null) {
        List<String> postImageUrls = List<String>.from(data['imageurl']);
        imageUrls.addAll(postImageUrls);
      }
    }
    print("Final image URLs: $imageUrls");
    return imageUrls;
  }

  Future<String?> getUsername() async {
    var userdata = MyUser().getCurrentUser();
    DocumentSnapshot doc =
    await FirebaseFirestore.instance.collection("users").doc(userdata.uid).get();

    if (doc.exists) {
      final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['username'] != null) {
        return data['username'];
      }
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading:IconButton(
          icon: Icon(Icons.arrow_back,size: 30.0,color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
            // Handle back button press
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                // Call the signOut function when the button is pressed
                signOut().then((_) {
                  // Navigate to the login screen after logout
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }).catchError((error) {
                  print('Error signing out: $error');
                });}
              ,
              child: Container(
                  width: 80,
                  height: 30,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Center(child: Text("Logout",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
              ),
            )
          )
        ],
      ),
      body: Stack(
          children: [
            Positioned(
              top: 50,
              left: 150,
              child: FutureBuilder<String?>(
                future: getUsername(), // Replace with the actual user ID
                builder: (context, usernameSnapshot) {
                  if (usernameSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (usernameSnapshot.hasError) {
                    return Text('Error: ${usernameSnapshot.error}');
                  } else if (usernameSnapshot.hasData) {
                    return Text(
                      '${usernameSnapshot.data}',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    );
                  } else {
                    return Text('No username available');
                  }
                },
              ),
            ),

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
                      top: 100,
                      left: 125,
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
            Positioned(
              top:300,
              left: 120,
              child:GestureDetector(
                onTap:(){  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateProfile()),);},
                child: Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.green
                ),
                child: Center(child: Text("Edit Profile",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                            ),
              ),),
            Positioned(
              top: 400,
              left: 20,
              child: FutureBuilder<List<String>>(
                future: getUserImages(),
                builder: (context, imagesSnapshot) {
                  if (imagesSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (imagesSnapshot.hasError) {
                    return Text('Error: ${imagesSnapshot.error}');
                  } else if (imagesSnapshot.hasData && imagesSnapshot.data!.isNotEmpty) {
                    return Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imagesSnapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imagesSnapshot.data![index],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Text('No images available');
                  }
                },
              ),
            ),
          ]),
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
    ));
  }

  Future<void> signOut() async {
    _showPopupDialog("User Logged Out");
    await FirebaseAuth.instance.signOut();
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