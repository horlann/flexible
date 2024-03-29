part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherUpdate extends WeatherEvent {}

class WeatherManualSwitch extends WeatherEvent {}

class LightManualSwitch extends WeatherEvent {}
