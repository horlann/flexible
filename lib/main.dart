import 'package:firebase_core/firebase_core.dart';
import 'package:flexible/flexible.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlexibleApp());
}
