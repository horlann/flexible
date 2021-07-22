import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

abstract class Task {
  GlobalKey? key;
  String? uuid;
  final String title;
  final String subtitle;
  final DateTime timeStart;
  final Duration period;
  final bool isDone;
  final bool isDonable;
  final bool timeLock;
  final Color color;
  final String iconId;

  Task({
    this.key,
    this.uuid,
    required this.title,
    required this.subtitle,
    required this.timeStart,
    required this.period,
    required this.isDone,
    required this.isDonable,
    required this.timeLock,
    required this.color,
    required this.iconId,
  }) {
    if (uuid == null) {
      this.uuid = Uuid().v1();
    }
  }

  Map<String, dynamic> toMap();
  Map<String, dynamic> toSqfMap();

  String toJson();

  copyWith({
    String? uuid,
    String? title,
    String? subtitle,
    DateTime? timeStart,
    Duration? period,
    bool? isDone,
    bool? isDonable,
    bool? timeLock,
    Color? color,
    String? iconId,
  });
  String toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.uuid == uuid &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.timeStart == timeStart &&
        other.period == period &&
        other.isDone == isDone &&
        other.isDonable == isDonable &&
        other.timeLock == timeLock &&
        other.color == color &&
        other.iconId == iconId;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        title.hashCode ^
        subtitle.hashCode ^
        timeStart.hashCode ^
        period.hashCode ^
        isDone.hashCode ^
        isDonable.hashCode ^
        timeLock.hashCode ^
        color.hashCode ^
        iconId.hashCode;
  }
}
