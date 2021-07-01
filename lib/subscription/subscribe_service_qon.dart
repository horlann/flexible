import 'dart:async';

import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscribeServiceQon {
  Future get launchQonverion => Qonversion.launch(
        'AZu-ZUfbWku3nY2f_ISom7XcMf2fMm6g',
        isObserveMode: false,
      );

  // Need to identify user throught platforms and apps
  Future setUserId(String id) async {
    await Qonversion.setUserId(id);
    await Qonversion.identify(id);
    print('Set user to Qonversion > $id');
  }

  // Future<List<QProduct>> products() async {
  //   try {
  //     final QOfferings offerings = await Qonversion.offerings();
  //     final List<QProduct> products = offerings.main!.products;
  //     if (products.isNotEmpty) {
  //       return products;
  //     }
  //     return [];
  //   } catch (e) {
  //     print('Get products > $e');
  //     return [];
  //   }
  // }

  // Future<QOffering?> getSub() async {
  //   try {
  //     final QOfferings offerings = await Qonversion.offerings();
  //     final QOffering? monthsuboffer =
  //         offerings.offeringForIdentifier("month_sub_offer");
  //     if (monthsuboffer != null) {
  //       return monthsuboffer;
  //     }
  //   } catch (e) {
  //     print('Get month_sub_offer > $e');
  //   }
  //   return null;
  // }

  // Start monthly subscribe purchase process
  Future<bool> makeSubMonth() async {
    Map<String, QPermission> permissions =
        await Qonversion.purchase('monthly_sub');
    final monSub = permissions['month_sub_perm'];
    print(permissions);
    if (monSub != null && monSub.isActive) {
      print(monSub.renewState);
      switch (monSub.renewState) {
        case QProductRenewState.willRenew:
        case QProductRenewState.nonRenewable:
          // .willRenew is the state of an auto-renewable subscription
          // .nonRenewable is the state of consumable/non-consumable IAPs that could unlock lifetime access
          break;
        case QProductRenewState.billingIssue:
          // Grace period: permission is active, but there was some billing issue.
          // Prompt the user to update the payment method.
          break;
        case QProductRenewState.canceled:
          // The user has turned off auto-renewal for the subscription, but the subscription has not expired yet.
          // Prompt the user to resubscribe with a special offer.
          break;
        default:
          break;
      }
      return true;
    }
    return false;
  }

  Future<bool> checkSubMonth() async {
    try {
      final Map<String, QPermission> permissions =
          await Qonversion.checkPermissions();
      final monSub = permissions['month_sub_perm'];
      print(permissions);
      if (monSub != null && monSub.isActive) {
        print(monSub.renewState);
        switch (monSub.renewState) {
          case QProductRenewState.willRenew:
          case QProductRenewState.nonRenewable:
            // .willRenew is the state of an auto-renewable subscription
            // .nonRenewable is the state of consumable/non-consumable IAPs that could unlock lifetime access
            break;
          case QProductRenewState.billingIssue:
            // Grace period: permission is active, but there was some billing issue.
            // Prompt the user to update the payment method.
            break;
          case QProductRenewState.canceled:
            // The user has turned off auto-renewal for the subscription, but the subscription has not expired yet.
            // Prompt the user to resubscribe with a special offer.
            break;
          default:
            break;
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Qonversion issue $e');
      return false;
    }
  }

  // Save localy subscribe state for offline mode
  saveSubStateLocaly({required bool didSubscribed}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('didSubscribed', didSubscribed);
  }

  Future<bool> get didSubscribed async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool didRun = prefs.getBool('didSubscribed') ?? false;
    return didRun;
  }
}
