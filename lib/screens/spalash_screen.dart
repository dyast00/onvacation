import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onvocation/screens/home_screen.dart';
import 'package:onvocation/screens/landing_page.dart';
import 'package:onvocation/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      navigateToNextScreen();
    });
  }

  void navigateToNextScreen() {
    // Cek status login
    if (isLoggedIn()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashBoard()),
      );
    }
  }

  bool isLoggedIn() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(102, 218, 255, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/Group%201742.png?alt=media&token=44db1ce5-82cd-473b-b9f8-77216dcf0c0c',
              width: 170,
              height: 170,
            ),
          ],
        ),
      ),
    );
  }
}
