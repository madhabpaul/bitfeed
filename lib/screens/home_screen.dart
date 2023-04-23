import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late StreamController<List<dynamic>> _streamController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<List<dynamic>>();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      fetchData();
    });
  }

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
            title: const Text('BitFeed'),
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
                        child: ListTile(
                          title: Text(
                            snapshot.data![index]['title'],
                            textAlign: TextAlign.justify,
                          ),
                          subtitle: Text(
                            snapshot.data![index]['description'],
                            textAlign: TextAlign.justify,
                          ),
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
