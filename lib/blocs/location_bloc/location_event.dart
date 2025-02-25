part of 'location_bloc.dart';

@immutable
sealed class LocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// event to search city names
class SearchCity extends LocationEvent {
  final String cityName;

  SearchCity(this.cityName);

  @override
  List<Object?> get props => [cityName];
}

// event to select the city
class SelectCity extends LocationEvent {
  final double lat;
  final double lon;

  SelectCity({required this.lat, required this.lon});

  @override
  List<Object?> get props => [lat, lon];
}

// event to clear city name
class ClearCity extends LocationEvent {
  @override
  List<Object?> get props => [];
}
