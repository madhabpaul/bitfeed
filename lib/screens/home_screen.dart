import 'dart:async';
import 'dart:convert';

import 'package:bitfeed/local_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:bitfeed/constants/global_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late StreamController<List<dynamic>> _streamController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    //Timer for fetching data from API  for realtime update
    _streamController = StreamController<List<dynamic>>();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      fetchData();
    });

    // Firebase Local Notification Settings
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Navigator.pushNamed(context, "/home");
      }
    });

    //when app is in foreground state
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        LocalNotificationServices.createNotification(message);
      }
    });

    //when app is in background and terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        LocalNotificationServices.createNotification(message);
      }
    });
  }

  //Fetching data from API and decoding JSON data
  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://64.227.170.215/bitfeed/getapi.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      _streamController.add(data);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BitFeed',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            leading: const Center(
                child: Padding(
              padding: EdgeInsets.all(5.0),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.teal,
                child: CircleAvatar(
                  backgroundImage: AssetImage(logo),
                  radius: 28,
                ),
              ),
            )),
            title: const Text(
              'BitFeed',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: StreamBuilder<List<dynamic>>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ExpansionTile(
                          title: Text(
                            snapshot.data![index]['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                snapshot.data![index]['description'],
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ));
  }
}
