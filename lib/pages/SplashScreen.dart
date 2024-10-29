// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_landscaping/pages/HomePage.dart';
import 'package:modern_landscaping/pages/SignInPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!);
    _animationController!.forward();
    Timer(Duration(seconds: 3), () async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _animation!,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: 1,
                duration: Duration(seconds: 1),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: screenHeight,
                  width: screenWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
