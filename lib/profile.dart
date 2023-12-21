import 'package:flutter/material.dart';
import 'package:netfusion/signup.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
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
      body: Container(
       child: Column(
         children:[
           Text("")
         ],
      ),
      ),
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
