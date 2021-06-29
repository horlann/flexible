import 'dart:async';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscribeService {
  Future<Offerings?> getOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        return offerings;
      }
    } on PlatformException catch (e) {
      print(e);
      // optional error handling
    }
  }

  Future isSubActive() async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
      if (purchaserInfo.entitlements.all["sub_month"]!.isActive) {
        print('User has month sub');
      }
    } on PlatformException catch (e) {
      print(e);
      // Error fetching purchaser info
    }
  }

  Future restorePurchashes() async {
    try {
      PurchaserInfo restoredInfo = await Purchases.restoreTransactions();
      print('Restored purshes');
      // ... check restored purchaserInfo to see if entitlement is now active
    } on PlatformException catch (e) {
      print(e);
      // Error restoring purchases
    }
  }

  Future makeSubscribe() async {
    Offerings? offs = await getOfferings();
    if (offs != null) {
      Offering? off = offs.getOffering('sub_month_off');

      if (off != null) {
        Package? pack = off.getPackage('Monthly');

        if (pack != null) {
          try {
            PurchaserInfo purchaserInfo = await Purchases.purchasePackage(pack);
            if (purchaserInfo.entitlements.all["sub_month"]!.isActive) {
              print('Purshase sucess');
            }
          } on PlatformException catch (e) {
            print(e);
          }
        }
      }
    }
  }
}
