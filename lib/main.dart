import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/blocs/location_bloc/location_bloc.dart';
import 'package:weather_app/blocs/storage_bloc/storage_bloc.dart';
import 'package:weather_app/blocs/weather_bloc/weather_bloc.dart';
import 'package:weather_app/repository/location_repository.dart';
import 'package:weather_app/repository/weather_repository.dart';
import 'package:weather_app/screens/no_internet_screen.dart';
import 'package:weather_app/screens/weather_screen.dart';
import 'package:weather_app/services/connectivity_service.dart';
import 'package:weather_app/services/storage_service.dart';

void main() async {
  // Ensures async services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // initialise internet connectivity
  final connectivityService = ConnectivityService();

  // Initialize SharedPreferences
  await SharedPreferences.getInstance();

  //load env file
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('API KEY Error: $e');
  }

  runApp(MyApp(connectivityService: connectivityService));
}

class MyApp extends StatelessWidget {
  final ConnectivityService connectivityService;
  const MyApp({super.key, required this.connectivityService});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocationBloc(LocationRepository())),
        BlocProvider(create: (context) => WeatherBloc(WeatherRepository())),
        BlocProvider(create: (context) => StorageBloc(StorageService())),
      ],
      child: MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Color.fromARGB(255, 15, 40, 54),
          brightness: Brightness.dark,
        ),
        home: StreamBuilder<ConnectivityResult>(
          stream: connectivityService.connectivityStream,
          builder: (context, snapshot) {
            // Add debugging to see what's happening
            print(
              "Connectivity snapshot: ${snapshot.connectionState}, ${snapshot.data}",
            );

            // If we're still waiting for the first value, check connectivity manually
            if (snapshot.connectionState == ConnectionState.waiting) {
              return FutureBuilder<bool>(
                future: connectivityService.checkInternetConnection(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return asyncSnapshot.data == true
                      ? const WeatherScreen()
                      : const NoInternetScreen();
                },
              );
            }

            // Process the stream data
            final hasInternet = snapshot.data != ConnectivityResult.none;
            return hasInternet
                ? const WeatherScreen()
                : const NoInternetScreen();
          },
        ),
      ),
    );
  }
}
