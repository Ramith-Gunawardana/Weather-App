import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/location_model.dart';

class LocationRepository {
  // create API KEY variable
  final apiKey = dotenv.env['API_KEY'];

  Future<List<LocationModel>> fetchLocations(String userInput) async {
    if (apiKey == null) {
      throw Exception("API key is not set");
    }

    // location URL
    var url = Uri.parse(
      'https://api.openweathermap.org/geo/1.0/direct?q=${Uri.encodeComponent(userInput)}&limit=10&appid=$apiKey',
    );

    try {
      if (userInput.isNotEmpty) {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          List<dynamic> data;
          try {
            if (response.body.isEmpty) {
              throw Exception("Response body is empty");
            }
            data = jsonDecode(response.body);
            if (data.isEmpty) {
              // Parsed data is empty - City not found
              return [];
            }
          } catch (e) {
            throw Exception("Failed to parse JSON: $e");
          }
          return LocationModel.fromJsonList(data);
        } else if (response.statusCode == 404) {
          // city not found
          throw Exception("City not found");
          // return [];
        } else {
          throw Exception(
            "Failed to load locations, Response code: ${response.statusCode}",
          );
        }
      } else {
        throw Exception("Empty user input");
      }
    } catch (e) {
      throw Exception("Failed to load locations: $e");
    }
  }
}
