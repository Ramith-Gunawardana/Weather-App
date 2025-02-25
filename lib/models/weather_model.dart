class WeatherModel {
  final double lat;
  final double lon;
  final int id;
  final String desc;
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double windSpeed;

  WeatherModel({
    required this.lat,
    required this.lon,
    required this.id,
    required this.desc,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
  });

  // convert JSON to model
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      lat: json['coord']['lat'].toDouble(),
      lon: json['coord']['lon'].toDouble(),
      id: json['weather'][0]['id'],
      desc: json['weather'][0]['description'],
      temp: json['main']['temp'].toInt(),
      feelsLike: json['main']['feels_like'].toInt(),
      tempMin: json['main']['temp_min'].toInt(),
      tempMax: json['main']['temp_max'].toInt(),
      pressure: json['main']['speed'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toInt(),
    );
  }
}
