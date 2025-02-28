import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:weather_app/screens/weather_screen.dart';
import 'package:weather_app/services/connectivity_service.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 145, 25, 75),
              const Color.fromARGB(255, 44, 0, 21),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 64, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                'No Internet Connection',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 48,
                width: 192,
                child: ElevatedButton(
                  onPressed: () {
                    // Manual check for internet connectivity
                    // Trigger connectivity check
                    context.read<ConnectivityBloc>().add(CheckConnectivity());

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No Internet connection'),
                        behavior: SnackBarBehavior.floating,
                        padding: EdgeInsets.all(16),
                        backgroundColor: Colors.white,
                      ),
                    );
                  },
                  child: const Text(
                    'Try Again',
                    textScaler: TextScaler.linear(1.2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
