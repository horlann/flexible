import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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

class Task {
  String? uuid;
  final String title;
  final String subtitle;
  final DateTime timeStart;
  final Duration period;
  final bool isDone;
  final bool isDonable;
  final Color color;
  Task({
    this.uuid,
    required this.title,
    required this.subtitle,
    required this.timeStart,
    required this.period,
    required this.isDone,
    required this.isDonable,
    required this.color,
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
      'color': color.toHex(),
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
      'isDonable': isDonable ? 1 : 0,
      'color': color.toHex(),
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
      color: HexColor.fromHex(map['color']),
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
      color: HexColor.fromHex(map['color']),
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
    Color? color,
  }) {
    return Task(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      timeStart: timeStart ?? this.timeStart,
      period: period ?? this.period,
      isDone: isDone ?? this.isDone,
      isDonable: isDonable ?? this.isDonable,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'Task(uuid: $uuid, title: $title, subtitle: $subtitle, timeStart: $timeStart, period: $period, isDone: $isDone, isDonable: $isDonable, color: $color)';
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
        other.color == color;
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
        color.hashCode;
  }
}
