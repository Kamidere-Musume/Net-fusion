import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:netfusion/firebase_auth/utilities.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override 
  build(BuildContext context) async {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
