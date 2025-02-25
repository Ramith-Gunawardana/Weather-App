part of 'storage_bloc.dart';

@immutable
sealed class StorageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// save location event
class SaveLocation extends StorageEvent {
  final double lat;
  final double lon;

  SaveLocation(this.lat, this.lon);

  @override
  List<Object?> get props => [lat, lon];
}

// get location event
class LoadLocation extends StorageEvent {}
