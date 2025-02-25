class LocationModel {
  final String name;
  final double lat;
  final double lon;
  final String? state;
  final String country;

  LocationModel({
    required this.name,
    required this.lat,
    required this.lon,
    required this.state,
    required this.country,
  });

  //convert JSON to model
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
      state: json['state'],
      country: json['country'],
    );
  }

  //convert list of JSON to list of Location objects
  static List<LocationModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LocationModel.fromJson(json)).toList();
  }
}
