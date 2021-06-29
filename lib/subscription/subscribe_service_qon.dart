import 'package:qonversion_flutter/qonversion_flutter.dart';

class SubscribeServiceQon {
  // SubscribeServiceQon() {}

  Future<List<QProduct>> products() async {
    try {
      final QOfferings offerings = await Qonversion.offerings();
      final List<QProduct> products = offerings.main!.products;
      if (products.isNotEmpty) {
        return products;
      }
      return [];
    } catch (e) {
      print('Get products > $e');
      return [];
    }
  }

  Future<QOffering?> getSub() async {
    try {
      final QOfferings offerings = await Qonversion.offerings();
      final QOffering? monthsuboffer =
          offerings.offeringForIdentifier("month_sub_offer");
      if (monthsuboffer != null) {
        return monthsuboffer;
      }
    } catch (e) {
      print('Get month_sub_offer > $e');
    }
    return null;
  }

  makeSubMonth() async {
    await Qonversion.purchase('monthly_sub');
  }

  checkSubMonth() async {
    final Map<String, QPermission> permissions =
        await Qonversion.checkPermissions();
    final main = permissions['month_sub_perm'];
    if (main != null && main.isActive) {
      switch (main.renewState) {
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
    }
  }
}
