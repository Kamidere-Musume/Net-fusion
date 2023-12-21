import 'package:flutter/material.dart';

class Signup2 extends StatelessWidget {
  const Signup2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Image.asset("assets/images/line4.png"),
            Image.asset("assets/images/line3.png"),
            Image.asset("assets/images/line2.png"),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text("Net Fusion",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}
