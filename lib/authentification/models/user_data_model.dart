import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UserData {
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final Uint8List? photo;
  final bool subscribed;
  final bool subscribedAllFeatures;
  final bool subscribedHideAds;
  UserData({
    String? uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.photo,
    this.subscribed = false,
    this.subscribedAllFeatures = false,
    this.subscribedHideAds = false,
  }) : this.uid = uid ?? Uuid().v1();

  UserData copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phoneNumber,
    Uint8List? photo,
    bool? subscribed,
    bool? subscribedAllFeatures,
    bool? subscribedHideAds,
  }) {
    return UserData(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photo: photo ?? this.photo,
      subscribed: subscribed ?? this.subscribed,
      subscribedAllFeatures: subscribedAllFeatures ?? this.subscribedAllFeatures,
      subscribedHideAds: subscribedHideAds ?? this.subscribedHideAds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'subscribed': subscribed,
      'subscribedAllFeatures': subscribedAllFeatures,
      'subscribedHideAds': subscribedHideAds,
      'photo': this.photo != null ? Blob(this.photo!) : null,
    };
  }

  Map<String, dynamic> onlyTextMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'subscribed': subscribed,
      'subscribedAllFeatures': subscribedAllFeatures,
      'subscribedHideAds': subscribedHideAds,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'],
      fullName: map['fullName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      photo: map['photo']?.bytes,
      subscribed: map['subscribed'] ?? false,
      subscribedAllFeatures: map['subscribedAllFeatures'] ?? false,
      subscribedHideAds: map['subscribedHideAds'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserData(uid: $uid, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, photo: $photo, subscribed: $subscribed, subscribedAllFeatures: $subscribedAllFeatures, subscribedHideAds: $subscribedHideAds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData &&
        other.uid == uid &&
        other.fullName == fullName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.photo == photo &&
        other.subscribed == subscribed &&
        other.subscribedAllFeatures == subscribedAllFeatures &&
        other.subscribedHideAds == subscribedHideAds;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        photo.hashCode ^
        subscribed.hashCode ^
        subscribedAllFeatures.hashCode ^
        subscribedHideAds.hashCode;
  }
}
