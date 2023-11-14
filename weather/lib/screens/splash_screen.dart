import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:weather/data/current_weather.dart';
import 'package:weather/data/seven_days_weather.dart';
import 'package:weather/data/seven_hours_weather.dart';
import 'package:weather/screens/home_screen.dart';

// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  SplashScreen({super.key, required this.currentPosition});
  Position currentPosition;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Position? currentPosition;
  String myId = '27e4790b473cf9e8ad44f29223be3ca9';
  bool showLoading = false;

  @override
  void initState() {
    currentPosition = widget.currentPosition;
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
        if (snapshot.hasData) {
          ConnectivityResult? result = snapshot.data;
          if (result == ConnectivityResult.mobile) {
            return connected('Mobile');
          } else if (result == ConnectivityResult.wifi) {
            return connected('WIFI');
          } else {
            return noInternet();
          }
        } else {
          return loading();
        }
      },
    ));
  }

  Widget loading() {
    return Center(
        child:
            LoadingAnimationWidget.newtonCradle(color: Colors.black, size: 70));
  }

  Widget connected(String type) {
    return Visibility(
      visible: showLoading,
      child: LoadingAnimationWidget.newtonCradle(color: Colors.black, size: 70),
    );
  }

  Widget noInternet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'images/wind.png',
          color: Colors.red,
          height: 100,
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          child: const Text(
            "No Internet connection",
            style: TextStyle(fontSize: 22),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: const Text("Check your connection, then refresh the page."),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
          ),
          onPressed: () async {
            ConnectivityResult result =
                await Connectivity().checkConnectivity();
            print(result);
          },
          child: const Text("Refresh"),
        ),
      ],
    );
  }

  void getData() async {
    try {
      var currentResponse = await Dio().get(
          'https://api.openweathermap.org/data/2.5/weather?lat=${currentPosition?.latitude}&lon=${currentPosition?.longitude}&appid=$myId&units=metric');

      var currentWeather = CurrentWeather.fromMapJson(currentResponse.data);

      var sevenDaysResponse = await Dio().get(
          'https://api.openweathermap.org/data/2.5/onecall?lat=${currentPosition?.latitude}&lon=${currentPosition?.longitude}&appid=$myId&units=metric');

      List<SevenDaysWeather> sevenDaysWeather = sevenDaysResponse.data['daily']
          .map<SevenDaysWeather>((json) => SevenDaysWeather.fromJsonMap(json))
          .toList();

      var sevenHoursResponse = await Dio().get(
          'https://api.openweathermap.org/data/2.5/onecall?lat=${currentPosition?.latitude}&lon=${currentPosition?.longitude}&appid=$myId&units=metric');
      List<SevenHoursWeather> sevenHoursWeather = sevenHoursResponse
          .data['hourly']
          .map<SevenHoursWeather>((json) => SevenHoursWeather.fromJsonMap(json))
          .toList();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              currentWeather: currentWeather,
              sevenDaysWeather: sevenDaysWeather,
              sevenHoursWeather: sevenHoursWeather,
            ),
          ));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
