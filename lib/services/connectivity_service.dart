import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> checkInternetConnection() async {
    // First check if we have network connectivity
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // Then verify we can actually reach the internet
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Stream<ConnectivityResult> get connectivityStream {
    return _connectivity.onConnectivityChanged.map((
      List<ConnectivityResult> results,
    ) {
      if (results.isEmpty) {
        return ConnectivityResult.none;
      }

      for (final result in results) {
        if (result != ConnectivityResult.none) {
          return result;
        }
      }

      return ConnectivityResult.none;
    });
  }
}
