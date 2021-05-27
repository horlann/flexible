import 'dart:convert';

import 'package:uuid/uuid.dart';

class Task {
  String? uuid;
  final String title;
  final String subtitle;
  final DateTime timeStart;
  final DateTime timeEnd;
  final bool isDone;
  final bool isDonable;
  Task({
    this.uuid,
    required this.title,
    required this.subtitle,
    required this.timeStart,
    required this.timeEnd,
    required this.isDone,
    required this.isDonable,
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
      'timeEnd': timeEnd.millisecondsSinceEpoch,
      'isDone': isDone,
      'isDonable': isDonable,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      uuid: map['uuid'],
      title: map['title'],
      subtitle: map['subtitle'],
      timeStart: DateTime.fromMillisecondsSinceEpoch(map['timeStart']),
      timeEnd: DateTime.fromMillisecondsSinceEpoch(map['timeEnd']),
      isDone: map['isDone'],
      isDonable: map['isDonable'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

  Task copyWith({
    String? uuid,
    String? title,
    String? subtitle,
    DateTime? timeStart,
    DateTime? timeEnd,
    bool? isDone,
    bool? isDonable,
  }) {
    return Task(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
      isDone: isDone ?? this.isDone,
      isDonable: isDonable ?? this.isDonable,
    );
  }

  @override
  String toString() {
    return 'Task(uuid: $uuid, title: $title, subtitle: $subtitle, timeStart: $timeStart, timeEnd: $timeEnd, isDone: $isDone, isDonable: $isDonable)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.uuid == uuid &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.timeStart == timeStart &&
        other.timeEnd == timeEnd &&
        other.isDone == isDone &&
        other.isDonable == isDonable;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        title.hashCode ^
        subtitle.hashCode ^
        timeStart.hashCode ^
        timeEnd.hashCode ^
        isDone.hashCode ^
        isDonable.hashCode;
  }
}
