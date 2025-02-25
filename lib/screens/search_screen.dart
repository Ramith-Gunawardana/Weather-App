import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/blocs/location_bloc/location_bloc.dart';
import 'package:weather_app/blocs/weather_bloc/weather_bloc.dart';
import 'package:weather_app/data/countries.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SearchAnchor(
                isFullScreen: false,
                shrinkWrap: true,
                builder: (context, controller) {
                  return SearchBar(
                    hintText: 'Enter city name',
                    controller: controller,
                    leading: Icon(Icons.search),
                    elevation: WidgetStatePropertyAll(0.0),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onChanged: (value) {
                      controller.openView();
                    },
                  );
                },
                viewShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                viewHintText: 'Enter city name',
                viewConstraints: BoxConstraints(minHeight: 0),
                viewElevation: 4.0,
                dividerColor: const Color.fromARGB(30, 0, 0, 0),
                viewOnChanged: (query) {
                  if (query.length > 2) {
                    context.read<LocationBloc>().add(SearchCity(query));
                  } else if (query.isEmpty) {
                    context.read<LocationBloc>().add(ClearCity());
                  }
                },
                suggestionsBuilder: (context, controller) {
                  return [
                    BlocBuilder<LocationBloc, LocationState>(
                      builder: (context, state) {
                        if (state is LocationLoading) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          );
                        } else if (state is LocationLoaded) {
                          return state.locations.isNotEmpty
                              ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.locations.length,
                                itemBuilder: (context, index) {
                                  final location = state.locations[index];
                                  final String cityName = location.name;
                                  final String country = getCountryName(
                                    location.country,
                                  );

                                  return ListTile(
                                    title: Text(cityName),
                                    subtitle:
                                        location.state == null
                                            ? Text(country)
                                            : Text(
                                              '${location.state!}, $country',
                                            ),
                                    onTap: () {
                                      print(location.lat);
                                      // context.read<WeatherBloc>().add();
                                      controller.closeView(cityName);
                                    },
                                  );
                                },
                              )
                              : ListTile(
                                title: Text('No cities found'),
                                leading: Icon(Icons.location_off_outlined),
                              );
                        } else if (state is LocationError) {
                          return Text(state.errorMessage);
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ];
                },
              ),

              // BlocBuilder<LocationBloc, LocationState>(
              //   builder: (context, state) {
              //     if (state is LocationLoading) {
              //       return CircularProgressIndicator();
              //     } else if (state is LocationLoaded) {
              //       return state.locations.isNotEmpty
              //           ? Expanded(
              //             child: ListView.builder(
              //               shrinkWrap: true,
              //               itemCount: state.locations.length,
              //               itemBuilder: (context, index) {
              //                 final location = state.locations[index];
              //                 String country = getCountryName(location.country);
              //                 return ListTile(
              //                   title: Text(location.name),
              //                   subtitle:
              //                       location.state == null
              //                           ? Text(country)
              //                           : Text('${location.state!}, $country'),
              //                   onTap: () {},
              //                 );
              //               },
              //             ),
              //           )
              //           : ListTile(
              //             title: Text('No cities found'),
              //             leading: Icon(Icons.location_off_outlined),
              //           );
              //     } else if (state is LocationError) {
              //       return Text(state.errorMessage);
              //     } else {
              //       return ListTile(
              //         title: Text('Current Location'),
              //         leading: Icon(Icons.location_searching_rounded),
              //         onTap: () {},
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
