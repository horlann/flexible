import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscribeService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
  late StreamSubscription _subscription;

  SubscribeService() {
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      print('purchase stream done');
      _subscription.cancel();
    }, onError: (error) {
      print('purchase stream error');
      // handle error here.
    });
    test();
  }

  Future test() async {
    // _inAppPurchase.
    print(await _inAppPurchase.isAvailable());
  }

  void _listenToPurchaseUpdated(purchaseDetailsList) {
    print('purchase stream new data');
    print(purchaseDetailsList);
  }

  Future productsCheck() async {
    ProductDetailsResponse purchasein = await InAppPurchase.instance
        .queryProductDetails(['sub_monthly_test'].toSet());

    ProductDetails det = purchasein.productDetails.first;

    print(PurchaseParam(productDetails: det).applicationUserName);
  }
}
