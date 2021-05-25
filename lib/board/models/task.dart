import 'dart:convert';

class Task {
  final String title;
  final String subtitle;
  final DateTime timeStart;
  final DateTime timeEnd;
  Task({
    required this.title,
    required this.subtitle,
    required this.timeStart,
    required this.timeEnd,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'timeStart': timeStart.millisecondsSinceEpoch,
      'timeEnd': timeEnd.millisecondsSinceEpoch,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      subtitle: map['subtitle'],
      timeStart: DateTime.fromMillisecondsSinceEpoch(map['timeStart']),
      timeEnd: DateTime.fromMillisecondsSinceEpoch(map['timeEnd']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}
