import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/model/save_loc.dart';
import 'package:weather/screens/permission_screen.dart';
import 'package:weather/screens/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SaveLocAdapter());
  await Hive.openBox<SaveLoc>('LocationBox');
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var seen = preferences.getBool('Seen') ?? false;
  runApp(seen ? const MyApp() : const FirstMyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          theme: ThemeData(fontFamily: 'SF'),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}

class FirstMyApp extends StatelessWidget {
  const FirstMyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          theme: ThemeData(fontFamily: 'SF'),
          debugShowCheckedModeBanner: false,
          home: const PermissionScreen(),
        );
      },
    );
  }
}
