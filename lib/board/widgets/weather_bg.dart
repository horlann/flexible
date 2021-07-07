import 'package:flexible/board/video_layer_fitted.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/weather/bloc/weather_bloc.dart';
import 'package:flexible/weather/openweather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Color colorByType(DayLight type) {
  if (type == DayLight.light) {
    return Color(0xff90e0ef);
  } else if (type == DayLight.medium) {
    return Color(0xff0096c7);
  } else {
    return Color(0xff023e8a);
  }
}

class WeatherBg extends StatefulWidget {
  const WeatherBg({Key? key}) : super(key: key);

  @override
  _WeatherBgState createState() => _WeatherBgState();
}

class _WeatherBgState extends State<WeatherBg> {
  String getWeatherAssetByCode(int code, DayLight dayl) {
    // code = 200;
    if ((code >= 801) && (code <= 802)) {
      if (dayl == DayLight.light) {
        return 'src/videobg_vertical/cloud_l.mp4';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg_vertical/cloud_m.mp4';
      } else {
        return 'src/videobg_vertical/cloud_d.mp4';
      }
    } else if ((code >= 802) && (code <= 804)) {
      if (dayl == DayLight.light) {
        return 'src/videobg_vertical/clouds_l.mp4';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg_vertical/clouds_m.mp4';
      } else {
        return 'src/videobg_vertical/clouds_d.mp4';
      }
    } else if ((code >= 700) && (code <= 799)) {
      if (dayl == DayLight.light) {
        return 'src/videobg_vertical/clouds_l.mp4';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg_vertical/clouds_m.mp4';
      } else {
        return 'src/videobg_vertical/clouds_d.mp4';
      }
    } else if ((code >= 600) && (code <= 622)) {
      if (dayl == DayLight.light) {
        return 'src/videobg_vertical/snow_l.mp4';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg_vertical/snow_m.mp4';
      } else {
        return 'src/videobg_vertical/snow_d.mp4';
      }
    } else if ((code >= 500) && (code <= 531)) {
      if (dayl == DayLight.light) {
        return 'src/videobg_vertical/rain_l.mp4';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg_vertical/rain_m.mp4';
      } else {
        return 'src/videobg_vertical/rain_d.mp4';
      }
    } else if ((code >= 300) && (code <= 321)) {
      if (dayl == DayLight.light) {
        return 'src/videobg_vertical/cloud_l.mp4';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg_vertical/cloud_m.mp4';
      } else {
        return 'src/videobg_vertical/cloud_d.mp4';
      }
    } else if ((code >= 200) && (code <= 232)) {
      if (dayl == DayLight.light) {
        return 'src/videobg_vertical/storm_l.mp4';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg_vertical/storm_m.mp4';
      } else {
        return 'src/videobg_vertical/storm_d.mp4';
      }
    } else {
      if (dayl == DayLight.light) {
        return 'src/videobg_vertical/sun_l.mp4';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg_vertical/sun_m.mp4';
      } else {
        return 'src/videobg_vertical/sun_d.mp4';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildBG();
  }

  Widget buildBG() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        print(state);
        if (state is WeatherError) {
          return Center(child: Text(state.error));
        }
        if (state is WeatherLoaded) {
          return VideoLayerFittedToBG(
              key: Key(getWeatherAssetByCode(state.wCode, state.daylight)),
              videoAsset: getWeatherAssetByCode(state.wCode, state.daylight),
              backgroundColor: colorByType(state.daylight));
        }

        return Center(child: Text('Loading'));
      },
    );
  }
}
