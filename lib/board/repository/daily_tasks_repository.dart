// import 'package:shared_preferences/shared_preferences.dart';

// class DailyTasksRepo {
//   SharedPreferences? prefs;

//   Future<SharedPreferences?> get getPrefs async {
//     if (prefs == null) {
//       prefs = await SharedPreferences.getInstance();
//       return prefs;
//     } return prefs;
//   }

//   List tasks => async{
//     Shared

//     return  getPrefs..getStringList('dailyTasks'); ?? [];
//   };

//   Future setList(List<String> tasks) async {

//     (await getPrefs)!..setStringList('dailyTasks', tasks);
//   }
// }
