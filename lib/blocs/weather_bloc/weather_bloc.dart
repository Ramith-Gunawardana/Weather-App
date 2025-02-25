import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/repository/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading());

      try {
        final weather = await weatherRepository.fetchWeather(
          event.lat,
          event.lon,
        );
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError('Failed to load weather: $e'));
      }
    });
  }
}
