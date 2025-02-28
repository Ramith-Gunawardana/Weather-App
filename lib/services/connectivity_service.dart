import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> checkInternetConnection() async {
    // First check if we have network connectivity
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.isEmpty ||
        connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }

    // Move the actual network lookup to a separate isolate
    return compute(_checkNetworkAccess, 'google.com');
  }

  // Static method required for compute()
  static Future<bool> _checkNetworkAccess(String host) async {
    try {
      final result = await InternetAddress.lookup(host);
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
