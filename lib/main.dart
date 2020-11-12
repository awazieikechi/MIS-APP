import 'package:flutter/material.dart';
import 'package:niia_mis_app/pages/login.dart';
import 'package:niia_mis_app/pages/home.dart';
import 'package:niia_mis_app/pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIS NIIA',
      home: CheckAuth(),
      navigatorKey: Get.key,
      routes: {
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/register': (context) => Register(),
      },
    );
  }
}

class CheckAuth extends StatefulWidget {
  CheckAuth({Key key}) : super(key: key);

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  @override
  bool isAuth = false;
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isAuth) {
      child = Home();
    } else {
      child = Login();
    }

    return Scaffold(
      body: child,
    );
  }
}
