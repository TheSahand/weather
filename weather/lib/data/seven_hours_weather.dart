class SevenHoursWeather {
  int time;
  var temp;
  String icon;
  SevenHoursWeather(this.time, this.temp, this.icon);

  factory SevenHoursWeather.fromJsonMap(Map<String, dynamic> json) {
    return SevenHoursWeather(
      json['dt'],
      json['temp'],
      json['weather'][0]['icon'],
    );
  }
}
