import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/blocs/location_bloc/location_bloc.dart';
import 'package:weather_app/blocs/storage_bloc/storage_bloc.dart';
import 'package:weather_app/data/countries.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select City'),
        backgroundColor: Color.fromARGB(218, 42, 141, 240),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 42, 142, 240),
              const Color.fromARGB(255, 0, 69, 138),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 16),
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
                            Color containerColor = const Color.fromARGB(
                              193,
                              255,
                              255,
                              255,
                            );
                            return ShimmerListTileWidget(
                              containerColor: containerColor,
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
                                        // save to local storage (shared pref)
                                        context.read<StorageBloc>().add(
                                          SaveLocation(
                                            location.lat,
                                            location.lon,
                                          ),
                                        );

                                        //close suggestion panel
                                        controller.closeView(cityName);

                                        // navigate back to weather screen
                                        Navigator.pop(context, location);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerListTileWidget extends StatelessWidget {
  const ShimmerListTileWidget({super.key, required this.containerColor});

  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(108, 245, 245, 245),
      highlightColor: Colors.white,
      enabled: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: Column(
              children: [
                // tile 1
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 192,
                      height: 16.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: containerColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: 96,
                      height: 16.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: containerColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // tile 2
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 192,
                      height: 16.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: containerColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: 96,
                      height: 16.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: containerColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // tile 3
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 192,
                      height: 16.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: containerColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: 96,
                      height: 16.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: containerColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
