import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/blocs/connectivity_bloc/connectivity_bloc.dart';
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
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Keep splash screen visible while initializing
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // initialise internet connectivity
  final connectivityService = ConnectivityService();

  // Initialize SharedPreferences
  await SharedPreferences.getInstance();

  // Pre-check connectivity
  final isConnected = await connectivityService.checkInternetConnection();

  //load env file
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('API KEY Error: $e');
  }

  // Remove splash screen when initialization is complete
  FlutterNativeSplash.remove();

  runApp(
    MyApp(
      connectivityService: connectivityService,
      initialConnectivity: isConnected,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ConnectivityService connectivityService;
  final bool initialConnectivity;

  const MyApp({
    super.key,
    required this.connectivityService,
    required this.initialConnectivity,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocationBloc(LocationRepository())),
        BlocProvider(create: (context) => WeatherBloc(WeatherRepository())),
        BlocProvider(
          create:
              (context) => StorageBloc(StorageService())..add(LoadLocation()),
        ),
        BlocProvider(
          create:
              (context) => ConnectivityBloc(connectivityService)..add(
                ConnectivityChanged(initialConnectivity),
              ), // Use pre-checked connectivity
        ),
      ],
      child: MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Color.fromARGB(255, 15, 40, 54),
          brightness: Brightness.dark,
        ),
        home: BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, state) {
            print(state);
            if (state is ConnectivityConnected) {
              return const WeatherScreen();
            } else if (state is ConnectivityDisconnected) {
              return const NoInternetScreen();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
