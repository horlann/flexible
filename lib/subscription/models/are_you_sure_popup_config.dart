import 'dart:convert';

import 'package:flutter/foundation.dart';

class AysConfig {
  final int id;
  final Map areyousuretitletext;

  final bool backtootoenable;
  final Map backtootoscreentext;

  final bool purchaseofferenable;
  final Map purchaseoffertext;

  final bool skiptoappenable;
  final Map skiptoapptext;

  AysConfig({
    required this.id,
    required this.areyousuretitletext,
    required this.backtootoenable,
    required this.backtootoscreentext,
    required this.purchaseofferenable,
    required this.purchaseoffertext,
    required this.skiptoappenable,
    required this.skiptoapptext,
  });

  factory AysConfig.fromMap(Map<String, dynamic> map) {
    return AysConfig(
      id: map['id'],
      areyousuretitletext: Map.from(map['are-you-sure-title-text']),
      backtootoenable: map['back-to-oto-enabled'],
      backtootoscreentext: Map.from(map['back-to-oto-screen-text']),
      purchaseofferenable: map['purchase-offer-enabled'],
      purchaseoffertext: Map.from(map['purchase-offer-text']),
      skiptoappenable: map['skip-to-app-enabled'],
      skiptoapptext: Map.from(map['skip-to-app-text']),
    );
  }

  factory AysConfig.fromJson(String source) =>
      AysConfig.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AysConfig(id: $id, areyousuretitletext: $areyousuretitletext, backtootoenable: $backtootoenable, backtootoscreentext: $backtootoscreentext, purchaseofferenable: $purchaseofferenable, purchaseoffertext: $purchaseoffertext, skiptoappenable: $skiptoappenable, skiptoapptext: $skiptoapptext)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AysConfig &&
        other.id == id &&
        mapEquals(other.areyousuretitletext, areyousuretitletext) &&
        other.backtootoenable == backtootoenable &&
        mapEquals(other.backtootoscreentext, backtootoscreentext) &&
        other.purchaseofferenable == purchaseofferenable &&
        mapEquals(other.purchaseoffertext, purchaseoffertext) &&
        other.skiptoappenable == skiptoappenable &&
        mapEquals(other.skiptoapptext, skiptoapptext);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        areyousuretitletext.hashCode ^
        backtootoenable.hashCode ^
        backtootoscreentext.hashCode ^
        purchaseofferenable.hashCode ^
        purchaseoffertext.hashCode ^
        skiptoappenable.hashCode ^
        skiptoapptext.hashCode;
  }
}
