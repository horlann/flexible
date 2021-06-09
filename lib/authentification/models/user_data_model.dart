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
  UserData({
    String? uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.photo,
  }) : this.uid = uid ?? Uuid().v1();

  UserData copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phoneNumber,
    Uint8List? photo,
  }) {
    return UserData(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photo': this.photo != null ? Blob(this.photo!) : null,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'],
      fullName: map['fullName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      photo: map['photo']?.bytes,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserData(uid: $uid, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, photo: $photo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData &&
        other.uid == uid &&
        other.fullName == fullName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.photo == photo;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        photo.hashCode;
  }
}
