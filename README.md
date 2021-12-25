# studio
A Studio project created in flutter using Pexels API. Studio supports mobile, clone the appropriate branches mentioned below:

'https://github.com/Yamunesh2108/studio'


## Getting Started

The Studio contains the minimal implementation required to create a new library or project. The repository code is preloaded with some basic components like basic app architecture, constants and required dependencies to create a new project.I use Pexels API for Images & Videos And use local storage to use it.


##Studio Feature

Splash
Home
Like/Images
Like/Videos
Videos
Search
Local Storage
Pexels API
Dependency
Widgets
Utils

##folder structure

studio/
|- android
|- build
|- ios
|- lib
|- test

#sub-structure

lib/
|- models/
|- screens/
|- utils/
|- generated_plugins_registrants/
|- main.dart


#Now, lets dive into the lib folder which has the main code for the application.

1- AppConstant - All the application level constants are defined in this directory with-in their respective files. This directory contains the constants for `theme`, `dimentions`, `api endpoints`, `preferences` and `strings`.
2- AppColors - Contains the colors of your project.
3- AppImages - Contains all the images of your application.
4- AppStrings - Contains all the Strings of your project,.
5- AppWidgets-Contains the common widgets for your applications. For example, Button, TextField etc.
6- main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.


##Main

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
