import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather/constants/colors.dart';
import 'package:weather/data/current_weather.dart';
import 'package:weather/data/search_weather.dart';
import 'package:weather/data/seven_days_weather.dart';
import 'package:weather/data/seven_hours_weather.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen(
      {super.key,
      required this.currentWeather,
      required this.sevenDaysWeather,
      required this.sevenHoursWeather});
  CurrentWeather currentWeather;
  List<SevenDaysWeather> sevenDaysWeather;
  List<SevenHoursWeather> sevenHoursWeather;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  CurrentWeather? currentWeather;
  List<SevenDaysWeather>? sevenDaysWeather;
  List<SevenHoursWeather>? sevenHoursWeather;
  String? cityName;
  String myId = 'Your key';
  List<SearchWeather>? searchWeather;
  double? latitude;
  double? longitude;
  bool showLoading = false;
  @override
  void initState() {
    currentWeather = widget.currentWeather;
    sevenDaysWeather = widget.sevenDaysWeather;
    sevenHoursWeather = widget.sevenHoursWeather;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColor.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 4.h, 4.w, 4.h),
              child: Column(
                children: [
                  SizedBox(
                    height: 6.h,
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                          hintText: 'Search your city',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 20.sp),
                          contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                          suffixIcon: IconButton(
                              splashRadius: 10,
                              onPressed: () {
                                setState(() {
                                  cityName = controller.text;
                                });
                                if (cityName == null || cityName == '') {
                                  return;
                                }
                                getLatAndLon();
                              },
                              icon: const Image(
                                  image: AssetImage('images/search.png'))),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: MyColor.lightBlue),
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    currentWeather!.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    height: 5.5.h,
                    width: 65.w,
                    decoration: const BoxDecoration(
                        color: MyColor.darkBlue,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Center(
                        child: Text(
                      dateNow(),
                      style: TextStyle(color: Colors.white, fontSize: 19.sp),
                    )),
                  ),
                  SizedBox(height: 1.h),
                  Row(children: [
                    Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            height: 24.h,
                            width: 35.w,
                            decoration: BoxDecoration(
                                color: Colors.white.withAlpha(30),
                                borderRadius: BorderRadius.circular(32)),
                            child: Center(
                              child: Text(
                                '${currentWeather!.temp.toStringAsFixed(1)}°',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 31.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    const Spacer(),
                    Image(
                        height: 45.w,
                        width: 45.w,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'http://openweathermap.org/img/w/${currentWeather!.icon}.png')),
                  ]),
                  SizedBox(height: 1.5.h),
                  Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          height: 20.h,
                          decoration: BoxDecoration(
                              color: Colors.white.withAlpha(30),
                              borderRadius: BorderRadius.circular(32)),
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Image(
                                                image: NetworkImage(
                                                    'http://openweathermap.org/img/w/${currentWeather!.icon}.png')),
                                            SizedBox(width: 2.w),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Real feel',
                                                    style: TextStyle(
                                                        fontSize: 19.sp,
                                                        color: Colors.white)),
                                                Text(
                                                    '${currentWeather!.feels_like}',
                                                    style: TextStyle(
                                                        fontSize: 17.sp,
                                                        color: Colors.white))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Image(
                                                height: 7.h,
                                                width: 7.w,
                                                image: const AssetImage(
                                                    'images/wind.png')),
                                            SizedBox(width: 2.w),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Wind',
                                                    style: TextStyle(
                                                        fontSize: 19.sp,
                                                        color: Colors.white)),
                                                Text(
                                                    '${currentWeather!.wind_speed} m/s',
                                                    style: TextStyle(
                                                        fontSize: 17.sp,
                                                        color: Colors.white))
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            const Image(
                                                image: NetworkImage(
                                                    'http://openweathermap.org/img/w/03d.png')),
                                            SizedBox(width: 2.w),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Clouds',
                                                    style: TextStyle(
                                                        fontSize: 19.sp,
                                                        color: Colors.white)),
                                                Text(
                                                    '${sevenDaysWeather![0].clouds}',
                                                    style: TextStyle(
                                                        fontSize: 17.sp,
                                                        color: Colors.white))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            const Image(
                                                image: NetworkImage(
                                                    'http://openweathermap.org/img/w/01d.png')),
                                            SizedBox(width: 2.w),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'UV index',
                                                  style: TextStyle(
                                                      fontSize: 19.sp,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  '${sevenDaysWeather![0].uvi}',
                                                  style: TextStyle(
                                                      fontSize: 17.sp,
                                                      color: Colors.white),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            DraggableScrollableSheet(
                initialChildSize: 0.25,
                minChildSize: 0.25,
                maxChildSize: 0.815,
                expand: true,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            color: Colors.white,
                            height: 2.7.h,
                            child: Center(
                              child: Container(
                                width: 25.w,
                                height: 0.7.h,
                                decoration: BoxDecoration(
                                    color: MyColor.lightBlack,
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 21.h,
                            child: ListView.builder(
                              itemCount: sevenDaysWeather?.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return index == 0
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: 4.w, right: 2.w),
                                        child: Container(
                                          width: 28.w,
                                          decoration: BoxDecoration(
                                              color: MyColor.darkBlue,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                'Now',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.sp),
                                              ),
                                              Text(
                                                dateDayAndMonthNow(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.sp),
                                              ),
                                              Image(
                                                  image: NetworkImage(
                                                      'http://openweathermap.org/img/w/${sevenDaysWeather![index].icon}.png')),
                                              Text(
                                                '${currentWeather!.temp}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 19.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 2.h),
                                        child: Container(
                                          width: 28.w,
                                          decoration: BoxDecoration(
                                              color: MyColor.lightLightBlue,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                dateDaySevenDays(index),
                                                style: TextStyle(
                                                    color: MyColor.darkBlack,
                                                    fontSize: 18.sp),
                                              ),
                                              Text(
                                                dateDayAndMonthSevenDays(index),
                                                style: TextStyle(
                                                    color: MyColor.darkBlack,
                                                    fontSize: 18.sp),
                                              ),
                                              Image(
                                                  image: NetworkImage(
                                                      'http://openweathermap.org/img/w/${sevenDaysWeather![index].icon}.png')),
                                              Text(
                                                '${sevenDaysWeather![index].temp}',
                                                style: TextStyle(
                                                    color: MyColor.darkBlack,
                                                    fontSize: 19.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                              },
                            ),
                          ),
                        ),
                        SliverPadding(padding: EdgeInsets.only(top: 2.h)),
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                                childCount: sevenDaysWeather?.length,
                                (context, index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(dateHourAndMinute(index)),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.w),
                                    child: Container(
                                      height: 20.w,
                                      width: 20.w,
                                      decoration: const BoxDecoration(
                                          color: MyColor.lightLightBlue,
                                          shape: BoxShape.circle),
                                      child: Image(
                                          image: NetworkImage(
                                              'http://openweathermap.org/img/w/${sevenHoursWeather![index].icon}.png')),
                                    ),
                                  ),
                                  Text(
                                      '${sevenHoursWeather![index].temp.toStringAsFixed(1)} °C'),
                                ],
                              ),
                              Divider(
                                indent: 20.w,
                                endIndent: 20.w,
                              )
                            ],
                          );
                        }))
                      ],
                    ),
                  );
                }),
            Visibility(
              visible: showLoading,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: LoadingAnimationWidget.newtonCradle(
                      color: Colors.black, size: 70),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String convertTimezoneToDate(int index) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        sevenDaysWeather![index].time * 1000);

    var d24 = DateFormat('dd').format(date);

    return d24.toString();
  }

  String dateNow() {
    final now = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM').format(now);

    return formattedDate.toString();
  }

  String dateDayAndMonthNow() {
    final now = DateTime.now();
    String formattedDate = DateFormat('d LLL').format(now);
    return formattedDate;
  }

  String dateDayAndMonthSevenDays(int index) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        sevenDaysWeather![index].time * 1000);
    String formattedDate = DateFormat('d LLL').format(date);
    return formattedDate;
  }

  String dateDaySevenDays(int index) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        sevenDaysWeather![index].time * 1000);
    String formattedDate = DateFormat('EEEE').format(date);
    return formattedDate;
  }

  String dateHourAndMinute(int index) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        sevenHoursWeather![index].time * 1000);
    String formattedDate = DateFormat('Hm').format(date);
    return formattedDate;
  }

  void getLatAndLon() async {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      showLoading = true;
    });
    var response = await Dio().get(
        'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=5&appid=$myId');
    List<SearchWeather> searchWeatherList = response.data
        .map<SearchWeather>((json) => SearchWeather.fromJsonMap(json))
        .toList();
    try {} catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      searchWeather = searchWeatherList;
      showLoading = false;
    });

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) => Dialog(
          child: Container(
        height: 30.h,
        color: Colors.white,
        child: searchWeather!.isEmpty
            ? const Center(
                child: Text('Not found'),
              )
            : ListView.builder(
                itemCount: searchWeather?.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(6),
                    child: GestureDetector(
                      onTap: () {
                        setLatAndLon(index);
                      },
                      child: Container(
                        color: MyColor.lightBlue,
                        height: 5.h,
                        child: Center(
                          child: Text(
                            '${searchWeather?[index].name} in ${searchWeather?[index].state ?? searchWeather?[index].name} (${searchWeather?[index].country})',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      )),
    );
  }

  void setLatAndLon(int index) async {
    Navigator.pop(context);
    setState(() {
      showLoading = true;
      latitude = searchWeather![index].lat;
      longitude = searchWeather![index].lon;
    });
    try {
      var currentResponse = await Dio().get(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$myId&units=metric');

      currentWeather = CurrentWeather.fromMapJson(currentResponse.data);

      var sevenDaysResponse = await Dio().get(
          'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&appid=$myId&units=metric');

      sevenDaysWeather = sevenDaysResponse.data['daily']
          .map<SevenDaysWeather>((json) => SevenDaysWeather.fromJsonMap(json))
          .toList();

      var sevenHoursResponse = await Dio().get(
          'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&appid=$myId&units=metric');
      sevenHoursWeather = sevenHoursResponse.data['hourly']
          .map<SevenHoursWeather>((json) => SevenHoursWeather.fromJsonMap(json))
          .toList();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      showLoading = false;
    });
  }
}
