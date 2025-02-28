part of 'connectivity_bloc.dart';

@immutable
sealed class ConnectivityState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ConnectivityInitial extends ConnectivityState {}

class ConnectivityLoading extends ConnectivityState {}

class ConnectivityConnected extends ConnectivityState {}

class ConnectivityDisconnected extends ConnectivityState {}
