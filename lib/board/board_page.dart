import 'package:flexible/board/widgets/weather_bg.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/weather/bloc/weather_bloc.dart';
import 'package:flexible/weather/openweather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexible/board/board.dart';
import 'package:flexible/board/bottom_date_picker.dart';

class BoardPage extends StatefulWidget {
  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  bool showCalendar = false;

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
          // image: DecorationImage(
          //     image: AssetImage('src/testbg.jpg'),
          //     fit: BoxFit.cover,
          //     alignment: Alignment.center),
        ),
        child: Stack(
          children: [
            //
            // Provide simple colored bg by weather
            //
            // BlocBuilder<WeatherBloc, WeatherState>(
            //   builder: (context, state) {
            //     if (state is WeatherLoaded) {
            //       print(state.daylight);
            //       return Container(
            //         color: colorByType(state.daylight),
            //       );
            //     }

            //     return SizedBox();
            //   },
            // ),
            //
            // Provide video bg by weather
            //
            Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: WeatherBg()),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: Board(),
                  ),
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

Color colorByType(DayLight type) {
  if (type == DayLight.light) {
    return Color(0xff90e0ef).withOpacity(0.5);
  } else if (type == DayLight.medium) {
    return Color(0xff0096c7).withOpacity(0.50);
  } else {
    return Color(0xff023e8a);
  }
}
