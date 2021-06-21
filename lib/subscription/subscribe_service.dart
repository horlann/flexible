import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

class SubscribeService {
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
  }

  final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
  late StreamSubscription _subscription;
  // final Stream purchasein = InAppPurchase.instance.queryProductDetails(identifiers)

  void _listenToPurchaseUpdated(purchaseDetailsList) {
    print('purchase stream new data');
    print(purchaseDetailsList);
  }
}
