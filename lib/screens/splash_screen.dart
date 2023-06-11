import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:bitfeed/constants/global_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  //splash screen time duration method
  // startTimer() {
  //   Timer(const Duration(seconds: 1), () {
  //     Navigator.pushReplacementNamed(context, "/home");
  //   });
  // }

  //init method for startTimer method call
  @override
  void initState() {
    super.initState();

    //startTimer();
    checkAndRequestNotificationPermission();
  }

  Future<void> checkAndRequestNotificationPermission() async {
    final PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      final PermissionStatus result = await Permission.notification.request();
      if (result.isDenied || result.isPermanentlyDenied) {
        // Handle denied permissions
        // Show a dialog or a message to inform the user
      }
    } else {
      Navigator.pushReplacementNamed(context, "/home");
    }
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
              ),
              const Padding(
                  padding: EdgeInsets.fromLTRB(20, 70, 20, 20),
                  child: Text(
                    'Turn on Notification Permission to proceed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
