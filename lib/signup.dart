import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netfusion/login.dart';
import 'package:netfusion/signup2.dart';
import 'package:netfusion/widgets/form_container_widget.dart';

import 'firebase_auth/firebase_auth_service.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupPageState();
  }
}
class SignupPageState extends State<SignupPage>{
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();


  Container getLinks({String? image, required String text,required color, required path}){
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          if (image != null) Padding(
            padding: const EdgeInsets.only(left: 25,right: 10),
            child: Image.asset(image,width: 20,),
          ),
          if (image == null) SizedBox(width: 60),
          GestureDetector(
              onTap: path,
              child: Text(text,style: TextStyle(fontWeight: FontWeight.bold),))
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          child: Column(
            children: [
              Image.asset("assets/images/line4.png"),
              Image.asset("assets/images/line3.png"),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("Net Fusion",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top:10),
                child: Container(
                  width: double.infinity,
                  height:800,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20,bottom: 30),
                        child: Text("Create a new account",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          getLinks(image: "assets/images/google.png", text: "Google",color: Colors.black,path: _signup),
                          SizedBox(width: 20,),
                          getLinks(image: "assets/images/facebook.png", text: "Facebook",color: Colors.black,path: _signup),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 100,
                            height: 2,
                            color: Colors.black,
                          ),
                          Text("OR",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                          Container(
                            width: 100,
                            height: 2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      SizedBox(height: 30,),

                      Padding(
                        padding: const EdgeInsets.only(left:50,right: 50),
                        child: Column(
                          children: [
                            FormContainerWidget(
                              hintText: "First name",
                              controller: _firstnameController,
                            ),
                            SizedBox(height: 20,),
                            FormContainerWidget(
                              hintText: "Last Name",
                              controller: _lastnameController,
                            ),
                            SizedBox(height: 20,),
                            FormContainerWidget(
                              hintText: "User Name",
                              controller: _usernameController,
                            ),
                            SizedBox(height: 20,),
                            FormContainerWidget(
                              hintText: "Email",
                              controller: _emailController,
                            ),
                            SizedBox(height: 20,),
                            FormContainerWidget(
                              hintText: "Password",
                              controller: _passwordController,
                            ),
                            SizedBox(height: 20,),
                            FormContainerWidget(
                              hintText: "Phone number",
                              controller: _numberController,
                            ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                      getLinks(text: "Signup", color: Colors.green, path: _signup)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void _signup()async{
    String username =_usernameController.text;
    String password =_passwordController.text;
    String  firstname =_firstnameController.text;
    String lastname =_lastnameController.text;
    String number = _numberController.text;
    String email = _emailController.text;

    User? user = await _auth.signup(email, password,username,firstname,lastname,number);

    if (user!= null){
      print("User is sucessfully created");
      Navigator.pushNamed(context,"/signup2");
    }
    else{
      print("Error");
    }
  }
}
