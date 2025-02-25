import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/blocs/location_bloc/location_bloc.dart';
import 'package:weather_app/repository/location_repository.dart';
import 'package:weather_app/screens/search_screen.dart';

void main() async {
  // Ensures async services are initialized
  WidgetsFlutterBinding.ensureInitialized();

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocationBloc(LocationRepository())),
      ],
      child: MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
        home: SearchScreen(),
      ),
    );
  }
}
