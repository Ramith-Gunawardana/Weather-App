import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/models/location_model.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherRepository {
  // create API KEY variable
  final apiKey = dotenv.env['API_KEY'];

  Future<WeatherModel> fetchWeather(LocationModel location) async {
    // final lat = location.lat;
    // final lon = location.lon;
    // weather URL
    var url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=California&appid=$apiKey&units=metric',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          "Failed to load weather, Response code: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Failed to load weather: $e");
    }
  }
}
