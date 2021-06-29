import 'package:firebase_core/firebase_core.dart';
import 'package:flexible/flexible.dart';
import 'package:flutter/material.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Qonversion.launch(
    'AZu-ZUfbWku3nY2f_ISom7XcMf2fMm6g',
    isObserveMode: false,
  );
  await Firebase.initializeApp();
  runApp(FlexibleApp());
}
