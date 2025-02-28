import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/blocs/storage_bloc/storage_bloc.dart';
import 'package:weather_app/blocs/weather_bloc/weather_bloc.dart';
import 'package:weather_app/models/location_model.dart';
import 'package:weather_app/screens/search_screen.dart';
import 'package:weather_app/services/weather_icon_service.dart';
import 'package:weather_app/utils/weather_gradients.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(71, 192, 192, 192),
        elevation: 0.0,
        tooltip: 'Add location',
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
          print(result);
          if (result != null && result is LocationModel && context.mounted) {
            final location = result;
            // Update weather with new location
            context.read<WeatherBloc>().add(
              FetchWeather(lat: location.lat, lon: location.lon),
            );
            // Save the location
            context.read<StorageBloc>().add(
              SaveLocation(location.lat, location.lon),
            );
          }
        },
        child: Image.asset('assets/icons/location.png', width: 24),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    state is WeatherLoaded
                        ? WeatherGradients.getGradientsByWeatherId(
                          state.weatherModel.id,
                          state.weatherModel.icon,
                        )
                        : [
                          const Color.fromARGB(255, 42, 142, 240),
                          const Color.fromARGB(255, 0, 69, 138),
                        ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: BlocBuilder<StorageBloc, StorageState>(
              builder: (context, state) {
                print(state);
                if (state is StorageLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is StorageLoaded) {
                  // Automatically fetch weather when storage is loaded
                  if (context.read<WeatherBloc>().state is! WeatherLoaded) {
                    context.read<WeatherBloc>().add(
                      FetchWeather(lat: state.latitude, lon: state.longitude),
                    );
                  }
                  return BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) {
                      if (state is WeatherLoading) {
                        Color containerColor = const Color.fromARGB(
                          193,
                          255,
                          255,
                          255,
                        );
                        return WeatherLoadingWidget(
                          containerColor: containerColor,
                        );
                      } else if (state is WeatherLoaded) {
                        return RefreshIndicator(
                          semanticsLabel: 'Pull to Refresh',
                          edgeOffset: 48,
                          onRefresh: () async {
                            context.read<WeatherBloc>().add(
                              FetchWeather(
                                lat: state.weatherModel.lat,
                                lon: state.weatherModel.lon,
                              ),
                            );
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //city
                                  Text(
                                    state.weatherModel.city,
                                    textScaler: TextScaler.linear(1.2),
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.headlineMedium,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                  ),
                                  SizedBox(height: 8),
                                  //temp
                                  Text(
                                    '${state.weatherModel.temp.toInt().toString()}°',
                                    textScaler: TextScaler.linear(1.5),
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.displayLarge,
                                  ),
                                  SizedBox(height: 32),
                                  //icon
                                  WeatherIconService(
                                    conditionId: state.weatherModel.id,
                                    iconCode: state.weatherModel.icon,
                                  ),
                                  // description
                                  Text(
                                    state.weatherModel.desc
                                        .split(' ')
                                        .map((word) => word.capitalize())
                                        .join(' '),
                                    textScaler: TextScaler.linear(1.8),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  SizedBox(height: 28),
                                  // high low temps
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'High: ${state.weatherModel.tempMax.toString()}°',
                                        textScaler: TextScaler.linear(1.2),
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                      ),
                                      SizedBox(width: 16),
                                      Text(
                                        'Low: ${state.weatherModel.tempMin.toString()}°',
                                        textScaler: TextScaler.linear(1.2),
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 32),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      //wind speed
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/wind.png',
                                            width: 24,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            '${(state.weatherModel.windSpeed).toInt()} km/h',
                                            textScaler: TextScaler.linear(1.2),
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      //humidity
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/humidity.png',
                                            width: 24,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            '${state.weatherModel.humidity.toInt()} %',
                                            textScaler: TextScaler.linear(1.2),
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      //pressure
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/pressure.png',
                                            width: 24,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            '${state.weatherModel.pressure} hPa',
                                            textScaler: TextScaler.linear(1.2),
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (state is WeatherError) {
                        return Text('Error: $state');
                      } else {
                        return Text('$state');
                      }
                    },
                  );
                } else if (state is StorageError) {
                  return Text(state.message);
                } else {
                  // First-time user experience
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Weather icon
                          Image.asset(
                            'assets/icons/802d.png',
                            width: 140,
                            height: 140,
                          ),
                          // Welcome text
                          Text(
                            'Welcome to Weather App',
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          // Description
                          Text(
                            'Get accurate weather information for any location around the world',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          // Call to action button
                          ElevatedButton.icon(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchScreen(),
                                ),
                              );

                              if (result != null &&
                                  result is LocationModel &&
                                  context.mounted) {
                                final location = result;
                                context.read<WeatherBloc>().add(
                                  FetchWeather(
                                    lat: location.lat,
                                    lon: location.lon,
                                  ),
                                );
                                context.read<StorageBloc>().add(
                                  SaveLocation(location.lat, location.lon),
                                );
                              }
                            },
                            icon: const Icon(Icons.add_location_alt_outlined),
                            label: const Text(
                              'Choose Your Location',

                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                71,
                                192,
                                192,
                                192,
                              ),
                              foregroundColor: Colors.white,
                              elevation: 0.0,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Help text
                          Text(
                            'Tap the button above or the location icon in the bottom right corner to get started',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class WeatherLoadingWidget extends StatelessWidget {
  const WeatherLoadingWidget({super.key, required this.containerColor});

  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(108, 245, 245, 245),
      highlightColor: Colors.white,
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        // spacing: screenHeight * 0.04,
        children: [
          SizedBox(height: 8),
          //city
          Container(
            width: 160,
            height: 36.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: containerColor,
            ),
          ),
          SizedBox(height: 8),
          //temp
          Container(
            width: 128,
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: containerColor,
            ),
          ),
          SizedBox(height: 8),
          //icon
          Container(
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: containerColor,
            ),
          ),
          SizedBox(height: 8),
          // description
          Container(
            width: 256,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: containerColor,
            ),
          ),
          SizedBox(height: 16),
          // high low temps
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: containerColor,
                ),
              ),
              SizedBox(width: 16),
              Container(
                width: 64,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: containerColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //wind speed
              Row(
                children: [
                  Image.asset('assets/icons/wind.png', width: 24),
                  SizedBox(width: 8),
                  Container(
                    width: 64,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: containerColor,
                    ),
                  ),
                ],
              ),
              //humidity
              Row(
                children: [
                  Image.asset('assets/icons/humidity.png', width: 24),
                  SizedBox(width: 8),
                  Container(
                    width: 64,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: containerColor,
                    ),
                  ),
                ],
              ),
              //pressure
              Row(
                children: [
                  Image.asset('assets/icons/pressure.png', width: 24),
                  SizedBox(width: 8),
                  Container(
                    width: 64,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: containerColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
