import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netfusion/signup.dart';

import 'firebase_auth/utilities.dart';

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupPage()),
            );
            // Handle back button press
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: MyDropdownButton(),
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
          Column(
            children: [
              Container(
                height: 200,

              )
            ],
          )
  ]),
    ));
  }
}

class MyDropdownButton extends StatefulWidget {
  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}
class _MyDropdownButtonState extends State<MyDropdownButton> {
  late String _selectedOption;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: Icon(
          Icons.more_vert,
          size: 30.0,
          color: Colors.white,
        ),
        items: [
          DropdownMenuItem(
            child: Text('Option 1',style: TextStyle(color: Colors.white)),
            value: 'Option 1',
          ),
          DropdownMenuItem(
            child: Text('Option 2',style: TextStyle(color: Colors.white)),
            value: 'Option 2',
          ),
          DropdownMenuItem(
            child: Text('Option 3',style: TextStyle(color: Colors.white)),
            value: 'Option 3',
          ),
        ],
        onChanged: (value) {
          setState(() {
            _selectedOption = value!;
          });
          // Handle the selected option here
          print('Selected: $_selectedOption');
        },
      ),
    );
  }
}
