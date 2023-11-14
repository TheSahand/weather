class SearchWeather {
  String name;
  double lat;
  double lon;
  String country;
  var state;
  SearchWeather(
    this.name,
    this.lat,
    this.lon,
    this.country,
    this.state,
  );

  factory SearchWeather.fromJsonMap(Map<String, dynamic> json) {
    return SearchWeather(
      json['name'],
      json['lat'],
      json['lon'],
      json['country'],
      json['state'],
    );
  }
}
