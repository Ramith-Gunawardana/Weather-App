part of 'weather_bloc.dart';

@immutable
sealed class WeatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

// initial state
final class WeatherInitial extends WeatherState {
  @override
  List<Object?> get props => [];
}

// loading state
class WeatherLoading extends WeatherState {
  @override
  List<Object?> get props => ['Loading...'];
}

// loaded weather model
class WeatherLoaded extends WeatherState {
  final WeatherModel weatherModel;

  WeatherLoaded(this.weatherModel);

  @override
  List<Object?> get props => [weatherModel];
}

// error state
class WeatherError extends WeatherState {
  final String errorMessage;

  WeatherError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
