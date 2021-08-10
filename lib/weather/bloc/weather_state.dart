part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  final String wTemp;
  final int wCode;
  final DayLight daylight;
  WeatherState({
    this.daylight = DayLight.light,
    this.wCode = 800,
    this.wTemp = '30',
  });

  @override
  List<Object> get props => [];
}

class WeatherLoading extends WeatherState {
  final DayLight daylight;
  WeatherLoading({
    this.daylight = DayLight.light,
  });
}

class WeatherError extends WeatherState {
  final DayLight daylight;
  final String error;
  WeatherError({
    this.daylight = DayLight.light,
    required this.error,
  });

  List<Object> get props => [error];
}

class WeatherLoaded extends WeatherState {
  final String wTemp;
  final int wCode;
  final DayLight daylight;
  final DateTime sunrise;
  final DateTime sunset;
  WeatherLoaded({
    required this.wTemp,
    required this.wCode,
    required this.daylight,
    required this.sunrise,
    required this.sunset,
  });

  @override
  List<Object> get props => [wTemp, wCode, daylight];

  WeatherLoaded copyWith({
    String? wTemp,
    int? wCode,
    DayLight? daylight,
    DateTime? sunrise,
    DateTime? sunset,
  }) {
    return WeatherLoaded(
      wTemp: wTemp ?? this.wTemp,
      wCode: wCode ?? this.wCode,
      daylight: daylight ?? this.daylight,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
    );
  }
}
