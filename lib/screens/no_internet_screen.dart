import 'package:flutter/material.dart';
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
              const Color.fromARGB(255, 44, 0, 21),
              const Color.fromARGB(255, 145, 25, 75),
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
                  onPressed: () async {
                    // Manual check for internet connectivity
                    final connectivity = ConnectivityService();
                    final hasInternet =
                        await connectivity.checkInternetConnection();

                    if (!context.mounted) return;

                    if (hasInternet) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WeatherScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No Internet connection'),
                          behavior: SnackBarBehavior.floating,
                          padding: EdgeInsets.all(16),
                          backgroundColor: Colors.white,
                        ),
                      );
                    }
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
