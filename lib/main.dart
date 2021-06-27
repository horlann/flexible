import 'package:firebase_core/firebase_core.dart';
import 'package:flexible/flexible.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initPlatformState();
  runApp(FlexibleApp());
}

Future<void> initPlatformState() async {
  await Purchases.setDebugLogsEnabled(true);
  await Purchases.setup("gLGeIUWnSjJSoaMpVKEvPbuzogDIGaoA");
}
