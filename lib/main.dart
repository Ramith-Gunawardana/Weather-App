import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/blocs/location_bloc/location_bloc.dart';
import 'package:weather_app/blocs/storage_bloc/storage_bloc.dart';
import 'package:weather_app/blocs/weather_bloc/weather_bloc.dart';
import 'package:weather_app/repository/location_repository.dart';
import 'package:weather_app/repository/weather_repository.dart';
import 'package:weather_app/screens/weather_screen.dart';
import 'package:weather_app/services/storage_service.dart';

void main() async {
  // Ensures async services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await SharedPreferences.getInstance();

  //load env file
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('API KEY Error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
        home: WeatherScreen(),
      ),
    );
  }
}
