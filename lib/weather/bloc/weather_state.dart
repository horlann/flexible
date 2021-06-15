part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  final DayLight daylight;
  WeatherState({
    this.daylight = DayLight.light,
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
  WeatherLoaded({
    required this.wTemp,
    required this.wCode,
    required this.daylight,
  });

  @override
  List<Object> get props => [wTemp, wCode];
}
