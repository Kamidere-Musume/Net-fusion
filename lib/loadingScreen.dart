import 'package:flutter/material.dart';

import 'login.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<void> fetchData() async {
    // Simulate an asynchronous operation (replace this with your actual data loading logic)
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 300),
              child: Container(
                  child: Column(
                    children: [
                      Image.asset("assets/images/netfusionlogo.png"),
                      Image.asset("assets/images/logo.png")
                    ],
                  ),
                ),
            ),
            );
          } else if (snapshot.hasError) {
            // Handle errors
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }  else {
            // Data has been loaded successfully, navigate to the login page
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(), // Replace LoginPage with your actual login page
                ),
              );
            });
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 300),
                child: Container(
                  child: Column(
                    children: [
                      Image.asset("assets/images/netfusionlogo.png"),
                      Image.asset("assets/images/logo.png")
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
