import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/model/save_loc.dart';
import 'package:weather/screens/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  Position? _currentPosition;
  bool showLoading = false;
  bool hideButton = true;
  var LocBox = Hive.box<SaveLoc>('LocationBox');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
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
        ),
      ),
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Turn on the GPS')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!hasPermission) return;
    setState(() {
      showLoading = true;
      hideButton = false;
    });
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SplashScreen(
              currentPosition: _currentPosition!,
            ),
          ));
      preferences.setBool('Seen', true);
      setState(() {
        _currentPosition = position;
      });
      saveLoc(_currentPosition!.latitude, _currentPosition!.longitude);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Widget loading() {
    return Center(
        child:
            LoadingAnimationWidget.newtonCradle(color: Colors.black, size: 70));
  }

  Widget connected(String type) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: hideButton,
          child: ElevatedButton(
              onPressed: () {
                _getCurrentPosition();
              },
              child: const Text('Find me')),
        ),
        Visibility(
          visible: showLoading,
          child: LoadingAnimationWidget.newtonCradle(
              color: Colors.black, size: 70),
        ),
      ],
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
            // You can also check the internet connection through this below function as well
            ConnectivityResult result =
                await Connectivity().checkConnectivity();
            print(result.toString());
          },
          child: const Text("Refresh"),
        ),
      ],
    );
  }

  void saveLoc(double lat, double lon) {
    var location = SaveLoc(lat, lon);
    LocBox.put(1, location);
    location.save();
  }
}
