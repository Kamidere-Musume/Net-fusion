import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:netfusion/homepage.dart';
import 'package:netfusion/loadingScreen.dart';
import 'package:netfusion/login.dart';
import 'package:netfusion/profile.dart';
import 'package:netfusion/signup.dart';
import 'package:netfusion/signup2.dart';
import 'package:netfusion/updateProfile.dart';
import 'package:netfusion/upload.dart';

import 'firebase_options.dart';
void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(apiKey: "AIzaSyB1HchpyrEaOQbzRKPhAXYaUq4jyLg22t0",
          appId:"1:458782984871:android:aa1edc66a1f2b9e177a982",
          messagingSenderId: "458782984871",
          projectId: "net-fusion-16728",
          ));
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key?key}): super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: TextTheme(
              bodyMedium: TextStyle(color: Colors.white)
          ),
          useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(background: Colors.black),
        ),
        home: LoadingScreen()
    );
  }
}
