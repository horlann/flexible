import 'dart:convert';

import 'package:flutter/foundation.dart';

class OtoConfig {
  final String id;
  final bool allotoiapremoveads;
  final Map imagesConfig;
  final Map fullPriceConfig;
  final Map? leftOfferConfig;
  final Map? rightOfferConfig;
  final Map? discountPriceConfig;
  final Map? orderBumpPriceConfig;
  final String? discountPercent;
  final String areYouSureQonversionID;
  OtoConfig({
    required this.id,
    required this.allotoiapremoveads,
    required this.imagesConfig,
    required this.fullPriceConfig,
    this.leftOfferConfig,
    this.rightOfferConfig,
    this.discountPriceConfig,
    this.orderBumpPriceConfig,
    this.discountPercent,
    required this.areYouSureQonversionID,
  });

  factory OtoConfig.fromMap(Map<String, dynamic> map) {
    return OtoConfig(
      id: map['id'],
      allotoiapremoveads: map['all-oto-iap-remove-ads'],
      imagesConfig: (map['ImagesConfig']),
      fullPriceConfig: (map['FullPriceConfig']),
      leftOfferConfig: (map['LeftOfferConfig']),
      rightOfferConfig: (map['RightOfferConfig']),
      discountPriceConfig: (map['DiscountPriceConfig']),
      orderBumpPriceConfig: (map['OrderBumpPriceConfig']),
      discountPercent: map['DiscountPercent'],
      areYouSureQonversionID: map['AreYouSureQonversionID'],
    );
  }

  factory OtoConfig.fromJson(String source) =>
      OtoConfig.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OtoConfig(id: $id, allotoiapremoveads: $allotoiapremoveads, imagesConfig: $imagesConfig, fullPriceConfig: $fullPriceConfig, leftOfferConfig: $leftOfferConfig, rightOfferConfig: $rightOfferConfig, discountPriceConfig: $discountPriceConfig, orderBumpPriceConfig: $orderBumpPriceConfig, discountPercent: $discountPercent, areYouSureQonversionID: $areYouSureQonversionID)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OtoConfig &&
        other.id == id &&
        other.allotoiapremoveads == allotoiapremoveads &&
        mapEquals(other.imagesConfig, imagesConfig) &&
        mapEquals(other.fullPriceConfig, fullPriceConfig) &&
        other.leftOfferConfig == leftOfferConfig &&
        other.rightOfferConfig == rightOfferConfig &&
        other.discountPriceConfig == discountPriceConfig &&
        other.orderBumpPriceConfig == orderBumpPriceConfig &&
        other.discountPercent == discountPercent &&
        other.areYouSureQonversionID == areYouSureQonversionID;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        allotoiapremoveads.hashCode ^
        imagesConfig.hashCode ^
        fullPriceConfig.hashCode ^
        leftOfferConfig.hashCode ^
        rightOfferConfig.hashCode ^
        discountPriceConfig.hashCode ^
        orderBumpPriceConfig.hashCode ^
        discountPercent.hashCode ^
        areYouSureQonversionID.hashCode;
  }
}
