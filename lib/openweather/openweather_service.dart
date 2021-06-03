import 'package:weather/weather.dart';

class OpenWeatherService {
  WeatherFactory wf = WeatherFactory('3634c96c808f11aff43c536ee9abeb05');

  Future<Weather>? weatherByCity(String city) async {
    late Weather w;
    try {
      w = await wf.currentWeatherByCityName(city);
    } catch (e) {
      print(e);
    }
    return w;
  }

  Future<Weather>? weatherByLocation(
      {required double lat, required double long}) async {
    late Weather w;
    try {
      w = await wf.currentWeatherByLocation(lat, long);
    } catch (e) {
      print(e);
    }
    return w;
  }
}
