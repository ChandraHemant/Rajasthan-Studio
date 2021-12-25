import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:studio/screens/PageNotFound.dart';
import 'package:studio/screens/VideoScreen.dart';
import 'package:studio/screens/HomeScreen.dart';
import 'package:studio/screens/ListingScreen.dart';
import 'package:studio/utils/AppColors.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}


class _MainDashboardState extends State<MainDashboard>
    with SingleTickerProviderStateMixin {
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: NotFoundPage(),
        );
        break;
      case ConnectivityResult.mobile:
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DashboardPage(),
        );
        break;
      case ConnectivityResult.wifi:
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DashboardPage(),
        );
        break;
    }
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }
}

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var selectedIndex = 0;

  List optionWidgets = <Widget>[
    HomeScreen(),
    ListingScreen(),
    VideoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color:
                  selectedIndex == 0 ? whiteColor : whiteColor.withOpacity(0.2),
              size: 35,
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: selectedIndex == 1
                    ? whiteColor
                    : whiteColor.withOpacity(0.2),
                size: 35,
              ),
              title: Text('')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.video_collection_outlined,
                color: selectedIndex == 2
                    ? whiteColor
                    : whiteColor.withOpacity(0.2),
                size: 35,
              ).cornerRadiusWithClipRRect(10),
              title: Text('')),
        ],
        onTap: onItemTapped,
        backgroundColor: PrimaryColor,
      ),
      body: optionWidgets.elementAt(selectedIndex),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      // print(selectedIndex);
    });
  }
}
