import 'dart:convert';

import 'package:flexible/board/models/tasks/task.dart';
import 'package:flutter/material.dart';

class RegularTask extends Task {
  final bool forAi;
  RegularTask({
    uuid,
    required title,
    required subtitle,
    required timeStart,
    required period,
    required isDone,
    required isDonable,
    required timeLock,
    required color,
    required iconId,
    required superTaskId,
    this.forAi = false,
  }) : super(
            uuid: uuid,
            title: title,
            subtitle: subtitle,
            timeStart: timeStart,
            period: period,
            isDone: isDone,
            isDonable: isDonable,
            timeLock: timeLock,
            color: color,
            iconId: iconId,
            superTaskId: superTaskId);

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
      'forAi': forAi,
      'superTaskId': superTaskId,
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
      'forAi': forAi ? 1 : 0,
      'superTaskId': superTaskId,
    };
  }

  factory RegularTask.fromMap(Map<String, dynamic> map) {
    return RegularTask(
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
      forAi: map['forAi'],
      superTaskId: map['superTaskId'],
    );
  }

  factory RegularTask.fromSqfMap(Map<String, dynamic> map) {
    return RegularTask(
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
      forAi: map['forAi'] == 1 ? true : false,
      superTaskId: map['superTaskId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RegularTask.fromJson(String source) =>
      RegularTask.fromMap(json.decode(source));

  RegularTask copyWith(
      {String? uuid,
      String? title,
      String? subtitle,
      DateTime? timeStart,
      Duration? period,
      bool? isDone,
      bool? isDonable,
      bool? timeLock,
      Color? color,
      String? iconId,
      String? superTaskId,
      bool? forAi}) {
    return RegularTask(
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
      forAi: forAi ?? this.forAi,
      superTaskId: superTaskId ?? this.superTaskId,
    );
  }

  @override
  String toString() {
    return 'RegularTask(uuid: $uuid, title: $title, subtitle: $subtitle, timeStart: $timeStart, period: $period, isDone: $isDone, isDonable: $isDonable, timeLock: $timeLock, color: $color, iconId: $iconId, superTaskId: $superTaskId))';
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
