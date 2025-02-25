part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// fetch weather
class FetchWeather extends WeatherEvent {
  final double lat;
  final double lon;

  FetchWeather({required this.lat, required this.lon});

  @override
  List<Object?> get props => [lat, lon];
}
