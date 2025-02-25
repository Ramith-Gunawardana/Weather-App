part of 'storage_bloc.dart';

@immutable
sealed class StorageState extends Equatable {
  @override
  List<Object?> get props => [];
}

// initial state
final class StorageInitial extends StorageState {}

// loading state
final class StorageLoading extends StorageState {}

// loaded location
final class StorageLoaded extends StorageState {
  final double latitude;
  final double longitude;

  StorageLoaded(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}

// State when location is saved successfully
class StorageSaved extends StorageState {}

// State when an error occurs
class StorageError extends StorageState {
  final String message;

  StorageError(this.message);

  @override
  List<Object?> get props => [message];
}
