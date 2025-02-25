part of 'location_bloc.dart';

@immutable
sealed class LocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

// initial state
final class LocationInitial extends LocationState {
  @override
  List<Object?> get props => [];
}

// loading state
class LocationLoading extends LocationState {
  @override
  List<Object?> get props => ['Loading...'];
}

// loaded sate with list of cities
class LocationLoaded extends LocationState {
  final List<LocationModel> locations;

  LocationLoaded(this.locations);

  @override
  List<Object?> get props => [locations];
}

// error state
class LocationError extends LocationState {
  final String errorMessage;

  LocationError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
