import 'dart:convert';

import 'package:flutter/foundation.dart';

class IsscConfig {
  final int id;
  final String lineabovepricetext;

  final String subscriptionduration;
  final String postpricetext;

  final String qonversionID;
  final String buttontitle;

  IsscConfig({
    required this.id,
    required this.lineabovepricetext,
    required this.subscriptionduration,
    required this.postpricetext,
    required this.qonversionID,
    required this.buttontitle,
  });

  factory IsscConfig.fromMap(Map<String, dynamic> map) {
    print("maps ${map.toString()}");
    return IsscConfig(
      id: map['id'],
      lineabovepricetext: map['Line-Above-Price-Text'] ?? "",
      subscriptionduration: map['Subscription-Duration'] ?? "",
      postpricetext: map['Post-Price-Text']?? "",
      qonversionID: map['QonversionID']?? "",
      buttontitle: map['Button-Title']?? "",
    );
  }

  factory IsscConfig.fromJson(String source){
      return IsscConfig.fromMap(json.decode(source));
  }

  @override
  String toString() {
    return 'IsscConfig(id: $id, lineabovepricetext: $lineabovepricetext, subscriptionduration: $subscriptionduration, postpricetext: $postpricetext, qonversionID: $qonversionID, buttontitle: $buttontitle)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IsscConfig &&
        other.id == id &&
        other.lineabovepricetext == lineabovepricetext &&
        other.subscriptionduration == subscriptionduration &&
        other.postpricetext == postpricetext &&
        other.qonversionID == qonversionID &&
        other.buttontitle == buttontitle;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        lineabovepricetext.hashCode ^
        subscriptionduration.hashCode ^
        postpricetext.hashCode ^
        qonversionID.hashCode ^
        buttontitle.hashCode;
  }
}
