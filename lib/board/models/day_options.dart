import 'dart:convert';

class DayOptions {
  final DateTime day;
  final DateTime wakeUpTime;
  final DateTime goToSleepTime;
  DayOptions({
    required this.day,
    required this.wakeUpTime,
    required this.goToSleepTime,
  });

  DayOptions copyWith({
    DateTime? day,
    DateTime? wakeUpTime,
    DateTime? goToSleepTime,
  }) {
    return DayOptions(
      day: day ?? this.day,
      wakeUpTime: wakeUpTime ?? this.wakeUpTime,
      goToSleepTime: goToSleepTime ?? this.goToSleepTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day.millisecondsSinceEpoch,
      'wakeUpTime': wakeUpTime.millisecondsSinceEpoch,
      'goToSleepTime': goToSleepTime.millisecondsSinceEpoch,
    };
  }

  factory DayOptions.fromMap(Map<String, dynamic> map) {
    return DayOptions(
      day: DateTime.fromMillisecondsSinceEpoch(map['day']),
      wakeUpTime: DateTime.fromMillisecondsSinceEpoch(map['wakeUpTime']),
      goToSleepTime: DateTime.fromMillisecondsSinceEpoch(map['goToSleepTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DayOptions.fromJson(String source) =>
      DayOptions.fromMap(json.decode(source));

  @override
  String toString() =>
      'DayOptions(day: $day, wakeUpTime: $wakeUpTime, goToSleepTime: $goToSleepTime)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DayOptions &&
        other.day == day &&
        other.wakeUpTime == wakeUpTime &&
        other.goToSleepTime == goToSleepTime;
  }

  @override
  int get hashCode =>
      day.hashCode ^ wakeUpTime.hashCode ^ goToSleepTime.hashCode;
}
