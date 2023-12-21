import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netfusion/signup.dart';
import 'package:netfusion/widgets/form_container_widget.dart';

import 'firebase_auth/firebase_auth_service.dart';
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}
class LoginPageState extends State<LoginPage>{
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
  }

  Container getLinks({String? image, required String text,required color, required path}){
    return Container(
      width: 220,
      height: 50,
      decoration: BoxDecoration(
          color: color,
        borderRadius: BorderRadius.circular(50)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != null) Image.asset(image),
          if (image != null) SizedBox(width: 10),
          SizedBox(width: 5,),
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
          Image.asset("assets/images/line2.png"),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text("Net Fusion",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                ),
          Padding(
            padding: const EdgeInsets.only(top:50),
            child: Container(
              width: double.infinity,
              height:500,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                  children: [
              Padding(
              padding: EdgeInsets.only(top: 20,bottom: 30),
              child: Text("Login into your account",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            ),
                    getLinks(image: "assets/images/google.png", text: "Sign in with google",color: Colors.black,path: null),
                    SizedBox(height: 20,),
                    getLinks(image: "assets/images/facebook.png", text: "Sign in with facebook",color: Colors.black,path: null),
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
                    Padding(
                      padding: const EdgeInsets.only(right: 50,left: 50),
                      child: Column(
                        children: [
                          FormContainerWidget(
                            hintText: "Email",
                            controller: _emailController,
                            isPasswordField: false,
                          ),
                          SizedBox(height: 10,),
                          FormContainerWidget(
                            hintText: "Password",
                            controller: _passwordController,
                            isPasswordField: false,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    getLinks(text: "Login", color: Colors.green,path: _signin),
                    Padding(
                      padding: const EdgeInsets.only(top:20),
                      child: Container(
                        width: 250,
                          child: Text("By creating an account, you agree with our Terms of Services & Privacy Policy",style: TextStyle(color: Colors.black),)),
                    )
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
  void _signin()async{

    String password =_passwordController.text;
    String email = _emailController.text;

    User? user = await _auth.signin(email, password);

    if (user!= null){
      print("User is sucessfully lggged in");
      Navigator.pushNamed(context,"lib/signup.dart");
    }
    else{
      print("Error");
    }
  }
}