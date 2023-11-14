class SevenDaysWeather {
  int time;
  var temp;
  String icon;
  var uvi;
  int clouds;

  SevenDaysWeather(
    this.time,
    this.temp,
    this.icon,
    this.uvi,
    this.clouds,
  );

  factory SevenDaysWeather.fromJsonMap(Map<String, dynamic> json) {
    return SevenDaysWeather(
      json['dt'],
      json['temp']['day'],
      json['weather'][0]['icon'],
      json['uvi'],
      json['clouds'],
    );
  }
}
