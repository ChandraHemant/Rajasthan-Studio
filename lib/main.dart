import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:studio/screens/dashboard.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: studio(),
  ));
}

// ignore: camel_case_types
class studio extends StatefulWidget {
  @override
  _studioState createState() => _studioState();
}

// ignore: camel_case_types
class _studioState extends State<studio> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 05,
      navigateAfterSeconds: MainDashboard(),
      title: Text(
        'Welcome To Rajasthan Studio',
        style: TextStyle(
            fontSize: 20, color: Colors.cyan, fontWeight: FontWeight.bold),
      ),
      image: Image.asset('images/studio.png'),
      backgroundColor: Colors.white,
      photoSize: 150.0,
    );
  }
}
