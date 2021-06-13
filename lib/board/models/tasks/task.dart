import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

abstract class Task {
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
}
