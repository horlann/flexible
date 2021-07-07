import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flexible/geolocation/geolocation_service.dart';
import 'package:flexible/weather/openweather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherLoading()) {
    // Auto update weather
    Timer.periodic(Duration(hours: 1), (t) {
      this.add(WeatherUpdate());
    });
  }

  WeatherFactory wf = WeatherFactory('3634c96c808f11aff43c536ee9abeb05');
  GeolocationService geolocationService = GeolocationService();

  String getWeatherTemp(Weather w) {
    return w.temperature!.celsius!.sign.isNegative
        ? '-'
        : '+' + w.temperature!.celsius!.ceil().toString();
  }

  int getWeatherCondition(Weather w) {
    return w.weatherConditionCode ?? 800;
  }

  DayLight getDayLight(Weather w) {
    DateTime sunset = w.sunset!;
    DateTime sunrise = w.sunrise!;
    Duration diff = sunset.difference(sunrise);
    var isNight = sunset.difference(DateTime.now()).isNegative &&
        sunrise.difference(DateTime.now()).isNegative;
    bool isLateDay =
        sunset.difference(DateTime.now()).inHours < diff.inHours / 4;

    if (isNight) {
      return DayLight.dark;
    } else if (isLateDay) {
      return DayLight.medium;
    } else {
      return DayLight.light;
    }
  }

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is WeatherUpdate) {
      // Determine position
      Position? curPos = await geolocationService.determinePosition();
      if (curPos != null) {
        try {
          // Load weather by location
          Weather weather = await wf.currentWeatherByLocation(
              curPos.latitude, curPos.longitude);

          // parse and go
          // yield WeatherLoaded(
          //     wTemp: getWeatherTemp(weather),
          //     wCode: getWeatherCondition(weather),
          //     daylight: getDayLight(weather));

          yield WeatherLoaded(
              wTemp: getWeatherTemp(weather),
              wCode: 232,
              daylight: DayLight.dark);
        } catch (e) {
          yield WeatherError(error: 'Service unevaliable');
        }
      } else {
        yield WeatherError(error: 'Location unevaliable');
      }
    }
  }
}
