class WeatherModel {
  final double lat;
  final double lon;
  final String city;
  final int id;
  final String desc;
  final String icon;
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
    required this.city,
    required this.id,
    required this.desc,
    required this.icon,
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
      city: json['name'],
      id: json['weather'][0]['id'],
      desc: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      temp: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }
}
