import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/services/storage_service.dart';

part 'storage_event.dart';
part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final StorageService storageService;

  StorageBloc(this.storageService) : super(StorageInitial()) {
    on<SaveLocation>((event, emit) async {
      try {
        await storageService.saveLocation(event.lat, event.lon);
        emit(StorageSaved());
        add(LoadLocation()); // Trigger LoadLocation event after saving
      } catch (e) {
        emit(StorageError("Failed to save location: $e"));
      }
    });
    on<LoadLocation>((event, emit) async {
      emit(StorageLoading());
      final double? lat = await storageService.getLatitude();
      final double? lon = await storageService.getLongitude();
      try {
        if (lat != null && lon != null) {
          emit(StorageLoaded(lat, lon));
        } else {
          // first run case
          emit(StorageInitial());
        }
      } catch (e) {
        emit(StorageError("Failed to load location: $e"));
      }
    });
  }
}
