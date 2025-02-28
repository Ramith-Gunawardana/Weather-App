import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/models/location_model.dart';
import 'package:weather_app/repository/location_repository.dart';
import 'package:weather_app/services/connectivity_service.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository locationRepository;

  LocationBloc(this.locationRepository) : super(LocationInitial()) {
    on<LocationEvent>((event, emit) async {
      if (event is SearchCity) {
        emit(LocationLoading());

        try {
          // Check connectivity before making network request
          final connectivityService = ConnectivityService();
          final hasInternet =
              await connectivityService.checkInternetConnection();

          if (!hasInternet) {
            emit(LocationError('No internet connection'));
            return;
          }
          if (event.cityName.isEmpty) {
            throw Exception("City name is null or empty");
          }
          final locations = await locationRepository.fetchLocations(
            event.cityName,
          );
          emit(LocationLoaded(locations));
        } catch (e) {
          emit(LocationError("Failed to load locations: $e"));
        }
      } else if (event is ClearCity) {
        // clear cities
        emit(LocationInitial());
      }
    });
  }
}
