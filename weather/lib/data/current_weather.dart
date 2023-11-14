class CurrentWeather {
  var feels_like;
  var wind_speed;
  int pressure;
  int humidity;
  String name;
  var temp;
  String icon;

  CurrentWeather(
    this.feels_like,
    this.wind_speed,
    this.pressure,
    this.humidity,
    this.name,
    this.temp,
    this.icon,
  );

  factory CurrentWeather.fromMapJson(Map<String, dynamic> json) {
    return CurrentWeather(
      json['main']['feels_like'],
      json['wind']['speed'],
      json['main']['pressure'],
      json['main']['humidity'],
      json['name'],
      json['main']['temp'],
      json['weather'][0]['icon'],
    );
  }
}
