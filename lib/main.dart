import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:waste/models/waste.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final Waste currWaste = Waste();
  runApp(App(currWaste: currWaste));
}
