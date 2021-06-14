import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_player/video_player.dart';
import 'package:weather/weather.dart';

import 'package:flexible/board/board.dart';
import 'package:flexible/board/bottom_date_picker.dart';
import 'package:flexible/geolocation/geolocation_service.dart';
import 'package:flexible/openweather/openweather_service.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';

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
            // gradient: mainBackgroundGradient,
            // image: DecorationImage(
            //     image: AssetImage('src/testbg.jpg'),
            //     fit: BoxFit.cover,
            //     alignment: Alignment.center),
            ),
        child: Stack(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: BackGroundByWeather()),
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

class BackGroundByWeather extends StatefulWidget {
  const BackGroundByWeather({Key? key}) : super(key: key);

  @override
  _BackGroundByWeatherState createState() => _BackGroundByWeatherState();
}

class _BackGroundByWeatherState extends State<BackGroundByWeather> {
  OpenWeatherService openWeatherService = OpenWeatherService();
  GeolocationService geolocationService = GeolocationService();
  int weatherConditionCode = 800;
  DayLight dayl = DayLight.light;

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

      // try {
      //   print(wthr!.toString());
      //   print(wthr.weatherConditionCode.toString());
      //   setState(() {
      //     weatherConditionCode = wthr?.weatherConditionCode ?? 800;
      //   });
      // } catch (e) {}
    }
  }

  @override
  void initState() {
    super.initState();
    getWeatherByLocation();
  }

  String get getWeatherAssetByCode {
    if ((weatherConditionCode >= 801) && (weatherConditionCode <= 802)) {
      return 'src/videobg/Sun-SemiSmallCloudComing.mp4';
    } else if ((weatherConditionCode >= 802) && (weatherConditionCode <= 803)) {
      return 'src/videobg/Sun-DarkiClouds.mp4';
    } else if ((weatherConditionCode >= 803) && (weatherConditionCode <= 804)) {
      return 'src/videobg/HavyDarkClouds-coming.mp4';
    } else if ((weatherConditionCode >= 600) && (weatherConditionCode <= 622)) {
      return 'src/videobg/Clouds-Snow.mp4';
    } else if ((weatherConditionCode >= 500) && (weatherConditionCode <= 531)) {
      return 'src/videobg/HavyDarkClouds-Rain.mp4';
    } else if ((weatherConditionCode >= 300) && (weatherConditionCode <= 321)) {
      return 'src/videobg/smallClouds-Coming.mp4';
    } else if ((weatherConditionCode >= 200) && (weatherConditionCode <= 232)) {
      return 'src/videobg/HavyDarkClouds-Rain-Storm.mp4';
    } else {
      if (dayl == DayLight.light) {
        return 'src/videobg/sub_light_gradient.mp4';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg/sub_medium_gradient.mp4';
      } else {
        return 'src/videobg/sub_dark_gradient.mp4';
      }
      // return 'src/videobg/sun_up.mp4';
    }
  }

  @override
  Widget build(BuildContext context) {
    String wAsset = getWeatherAssetByCode;
    print(wAsset);
    // getWeatherByLocation();
    return VideoBackGround(
        videoAsset: wAsset, backgroundColor: colorByType(dayl));
  }
}

// void getDarkness

class VideoBackGround extends StatefulWidget {
  final String videoAsset;
  final Color backgroundColor;
  const VideoBackGround({
    Key? key,
    required this.videoAsset,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _VideoBackGroundState createState() => _VideoBackGroundState();
}

class _VideoBackGroundState extends State<VideoBackGround> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAsset)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  void didUpdateWidget(covariant VideoBackGround oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller = VideoPlayerController.asset(widget.videoAsset)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
        child: _controller.value.isInitialized
            ? Container(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

enum DayLight { light, medium, dark }
Color colorByType(DayLight type) {
  if (type == DayLight.light) {
    return Color(0xff90e0ef);
  } else if (type == DayLight.medium) {
    return Color(0xff0096c7);
  } else {
    return Color(0xff023e8a);
  }
}
