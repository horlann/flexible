import 'dart:async';

import 'package:flexible/board/board.dart';
import 'package:flexible/board/bottom_date_picker.dart';
import 'package:flexible/geolocation/geolocation_service.dart';
import 'package:flexible/openweather/openweather_service.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class BoardPage extends StatefulWidget {
  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  OpenWeatherService openWeatherService = OpenWeatherService();
  GeolocationService geolocationService = GeolocationService();
  String weatherDescription = '';
  bool showCalendar = false;

  Future<void> wthr() async {
    print(await openWeatherService.weatherByCity('dobropillya'));
  }

  void getWeatherByLocation() async {
    Position? curpos;
    try {
      curpos = await geolocationService.determinePosition();
    } catch (e) {
      print(e);
    }

    if (curpos != null) {
      Weather? wthr;
      try {
        wthr = await openWeatherService.weatherByLocation(
            lat: curpos.latitude, long: curpos.longitude);
      } catch (e) {
        print(e);
      }
      print(wthr.toString());

      if (wthr != null) {
        setState(() {
          weatherDescription = wthr.toString();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // getWeatherByLocation();
  }

  @override
  Widget build(BuildContext context) {
    // Lock portreit mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Color(0xffE9E9E9),
      body: SizedBox.expand(
          child: Container(
        decoration: BoxDecoration(
          gradient: mainBackgroundGradient,
          image: DecorationImage(
              image: AssetImage('src/testbg.jpg'),
              fit: BoxFit.cover,
              alignment: Alignment.center),
        ),
        child: Stack(
          children: [
            // WeatherBg(
            //   weatherType: WeatherType.overcast,
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height,
            // ),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(child: Board()),
                  SizedBox(
                    height: 16,
                  ),
                  BottomDatePicker(),
                  // Container(
                  //   color: Colors.white,
                  //   margin: EdgeInsets.all(8),
                  //   padding: EdgeInsets.all(8),
                  //   child: Text(weatherDescription.isEmpty
                  //       ? 'NO PAGODA'
                  //       : weatherDescription),
                  // ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
