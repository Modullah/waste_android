//import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_analytics/observer.dart';
import 'package:waste/models/waste.dart';
import 'package:flutter/material.dart';
import 'screens/list.dart';

class App extends StatefulWidget {
  final Waste currWaste;
  const App({Key? key, required this.currWaste}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  //static FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        iconTheme: IconThemeData(color: Colors.white30),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.black26, foregroundColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: List(
        currWaste: widget.currWaste,
      ),
      //navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
    );
  }
}
