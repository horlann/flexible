import 'package:shared_preferences/shared_preferences.dart';

class FirstTimeService {
  get isAppRunsFirst async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool didRun = prefs.getBool('didRun') ?? false;
    return didRun;
  }

  markAsRunned() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('didRun', true);
  }
}
