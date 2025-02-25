import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  String latKey = "latitude_key";
  String lonKey = "longitude_key";

  Future<void> saveLocation(double lat, double lon) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(latKey, lat);
    await prefs.setDouble(lonKey, lon);
  }

  Future<double?> getLatitude() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(latKey); // Returns null if not found
  }

  Future<double?> getLongitude() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(lonKey); // Returns null if not found
  }
}
