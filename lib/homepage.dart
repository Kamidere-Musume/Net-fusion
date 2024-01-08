import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netfusion/firebase_auth/utilities.dart';
import 'package:netfusion/profile.dart';
import 'package:netfusion/upload.dart';
import 'package:netfusion/widgets/form_container_widget.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() {
    return HomepageState();
  }
}

class HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Flexible(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("posts").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print("error");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data == null) {
                    return const Text("No Data");
                  }
                  final posts = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return Container(
                          child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                            Padding(
                              padding: const EdgeInsets.only(left: 170),
                              child: Container(
                                width: 230,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(50)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FutureBuilder<String?>(
                                        future: getProfilePicture(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text('Error: ${snapshot.error}');
                                          } else if (snapshot.hasData) {
                                            return Container(
                                              width: 60,
                                              height: 60,
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
                                            );
                                          } else {
                                            return Text('No profile picture available');
                                          }
                                        },
                                      ),
                                      SizedBox(width: 10,),
                                      Text("@"+posts[index]['username'],style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Center(
                              child: Container(
                                  width: 350,
                                  height: 400,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(70),
                                      border: Border.all(
                                        color: Colors.green, // Set the border color
                                        width: 5, // Set the border width
                                      )
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(70),
                                      child: Image.network(posts[index]['imageurl'],fit: BoxFit.cover ,))),
                            ),
                              SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Container(
                                  child: Row(
                                    children: [
                                      Image.asset("assets/images/like.png"),
                                      SizedBox(width: 20,),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Container(
                                  width: 330,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 30,top: 10),
                                    child: Text(posts[index]['username']+":"+posts[index]['caption'],style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.normal),),
                                  ),
                                ),
                              ),
                                SizedBox(height: 20,)
                              ]));
                    },
                  );
                },
              ),
            )
          ],
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
}