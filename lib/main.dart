import 'package:firebase_core/firebase_core.dart';
import 'package:flexible/flexible.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
  runApp(FlexibleApp());
}
