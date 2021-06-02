import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Task {
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

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'title': title,
      'subtitle': subtitle,
      'timeStart': timeStart.millisecondsSinceEpoch,
      'period': period.inMilliseconds,
      'isDone': isDone,
      'isDonable': isDonable,
      'timeLock': timeLock,
      'color': color.value,
      'iconId': iconId,
    };
  }

  Map<String, dynamic> toSqfMap() {
    return {
      'uuid': uuid,
      'title': title,
      'subtitle': subtitle,
      'timeStart': timeStart.millisecondsSinceEpoch,
      'period': period.inMilliseconds,
      'isDone': isDone ? 1 : 0,
      'timeLock': timeLock ? 1 : 0,
      'isDonable': isDonable ? 1 : 0,
      'color': color.toHex(),
      'iconId': iconId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      uuid: map['uuid'],
      title: map['title'],
      subtitle: map['subtitle'],
      timeStart: DateTime.fromMillisecondsSinceEpoch(map['timeStart']),
      period: Duration(milliseconds: map['period']),
      isDone: map['isDone'],
      isDonable: map['isDonable'],
      timeLock: map['timeLock'],
      color: Color(map['color']),
      iconId: map['iconId'],
    );
  }

  factory Task.fromSqfMap(Map<String, dynamic> map) {
    return Task(
      uuid: map['uuid'],
      title: map['title'],
      subtitle: map['subtitle'],
      timeStart: DateTime.fromMillisecondsSinceEpoch(map['timeStart']),
      period: Duration(milliseconds: map['period']),
      isDone: map['isDone'] == 1 ? true : false,
      isDonable: map['isDonable'] == 1 ? true : false,
      timeLock: map['timeLock'] == 1 ? true : false,
      color: HexColor.fromHex(map['color']),
      iconId: map['iconId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

  Task copyWith({
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
  }) {
    return Task(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      timeStart: timeStart ?? this.timeStart,
      period: period ?? this.period,
      isDone: isDone ?? this.isDone,
      isDonable: isDonable ?? this.isDonable,
      timeLock: timeLock ?? this.timeLock,
      color: color ?? this.color,
      iconId: iconId ?? this.iconId,
    );
  }

  @override
  String toString() {
    return 'Task(uuid: $uuid, title: $title, subtitle: $subtitle, timeStart: $timeStart, period: $period, isDone: $isDone, isDonable: $isDonable, timeLock: $timeLock, color: $color, iconId: $iconId)';
  }

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

// Usese for parse color to string
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
