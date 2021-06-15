import 'package:flexible/geolocation/geolocation_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

enum DayLight { light, medium, dark }

class OpenWeatherService {
  WeatherFactory wf = WeatherFactory('3634c96c808f11aff43c536ee9abeb05');
  GeolocationService geolocationService = GeolocationService();
  Weather? w;

  initWeather() async {
    Position? curpos;
    curpos = await geolocationService.determinePosition();

    if (curpos != null) {
      w = await wf.currentWeatherByLocation(curpos.latitude, curpos.longitude);
    }
  }

  Future<int?> getWeatherCondition() async {
    try {
      if (w == null) {
        await initWeather();
      }
      return w!.weatherConditionCode;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getWeatherTemp() async {
    try {
      if (w == null) {
        await initWeather();
      }

      return w!.temperature!.celsius!.sign.isNegative
          ? '-'
          : '+' + w!.temperature!.celsius!.ceil().toString();
    } catch (e) {
      return null;
    }
  }

  Future<DayLight?> getDayLight() async {
    try {
      if (w == null) {
        await initWeather();
      }

      // Set daylight by weather service
      DateTime sunset = w!.sunset!;
      DateTime sunrise = w!.sunrise!;
      Duration diff = sunset.difference(sunrise);
      var isNight = sunset.difference(DateTime.now()).isNegative &&
          sunrise.difference(DateTime.now()).isNegative;
      bool isLateDay =
          sunset.difference(DateTime.now()).inHours < diff.inHours / 4;

      if (isLateDay) {
        return DayLight.medium;
      } else if (isNight) {
        return DayLight.dark;
      } else {
        return DayLight.light;
      }
    } catch (e) {
      return null;
    }
  }
}
