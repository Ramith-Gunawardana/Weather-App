import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/services/connectivity_service.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService;
  StreamSubscription? _connectivitySubscription;

  ConnectivityBloc(this._connectivityService) : super(ConnectivityInitial()) {
    on<CheckConnectivity>(_onCheckConnectivity);
    on<ConnectivityChanged>(_onConnectivityChanged);

    // Initialize connectivity monitoring
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    // Check initial connectivity
    add(CheckConnectivity());

    // Listen for connectivity changes
    _connectivitySubscription = _connectivityService.connectivityStream.listen((
      result,
    ) async {
      final isConnected = result != ConnectivityResult.none;

      // Verify internet access when connectivity is available
      if (isConnected) {
        final hasInternet =
            await _connectivityService.checkInternetConnection();
        add(ConnectivityChanged(hasInternet));
      } else {
        add(ConnectivityChanged(false));
      }
    });
  }

  Future<void> _onCheckConnectivity(
    CheckConnectivity event,
    Emitter<ConnectivityState> emit,
  ) async {
    emit(ConnectivityLoading());

    try {
      final isConnected = await _connectivityService.checkInternetConnection();

      if (isConnected) {
        emit(ConnectivityConnected());
      } else {
        emit(ConnectivityDisconnected());
      }
    } catch (_) {
      emit(ConnectivityDisconnected());
    }
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    if (event.isConnected) {
      emit(ConnectivityConnected());
    } else {
      emit(ConnectivityDisconnected());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
