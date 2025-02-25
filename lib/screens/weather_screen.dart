import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/blocs/location_bloc/location_bloc.dart';
import 'package:weather_app/blocs/storage_bloc/storage_bloc.dart';
import 'package:weather_app/blocs/weather_bloc/weather_bloc.dart';
import 'package:weather_app/models/location_model.dart';
import 'package:weather_app/repository/weather_repository.dart';
import 'package:weather_app/screens/search_screen.dart';
import 'package:weather_app/services/storage_service.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double lat = 0;
    double lon = 0;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );

          if (result != null && result is LocationModel) {
            final location = result;
            context.read<WeatherBloc>().add(
              FetchWeather(lat: location.lat, lon: location.lon),
            );
            context.read<StorageBloc>().add(LoadLocation());
          }
        },
      ),
      body: SafeArea(
        child: BlocBuilder<StorageBloc, StorageState>(
          builder: (context, state) {
            print(state);
            if (state is StorageLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StorageLoaded) {
              return Text('${state.latitude}, ${state.longitude}');
            } else if (state is StorageError) {
              return Text(state.message);
            } else {
              return Text('No saved location');
            }
          },
        ),
      ),
    );
  }
}
