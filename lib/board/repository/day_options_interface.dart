import 'package:flexible/board/models/day_options.dart';

abstract class IDayOptionsRepo {
  Future addDayOptions(DayOptions dayOptions);
  Future updateDayOptions(DayOptions dayOptions);
  Future deleteDayOptions(DayOptions dayOptions);
  Future<DayOptions> getDayOptionsByDate(DateTime date);
}
