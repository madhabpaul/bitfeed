import 'package:flutter/material.dart';
import 'dart:async';

import 'package:bitfeed/constants/global_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  //splash screen time duration method
  startTimer() {
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, "/home");
    });
  }

  //init method for startTimer method call
  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                logo,
                fit: BoxFit.cover,
              ),
              const Text(
                slogan,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
