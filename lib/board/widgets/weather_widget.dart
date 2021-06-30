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

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String getWeatherAssetByCode(int code, DayLight dayl) {
    if ((code >= 801) && (code <= 802)) {
      if (dayl == DayLight.light) {
        return 'src/videobg/cloud_l.mov';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg/cloud_m.mov';
      } else {
        return 'src/videobg/cloud_d.mov';
      }
    } else if ((code >= 802) && (code <= 804)) {
      if (dayl == DayLight.light) {
        return 'src/videobg/clouds_l.mov';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg/clouds_m.mov';
      } else {
        return 'src/videobg/clouds_d.mov';
      }
    } else if ((code >= 700) && (code <= 799)) {
      if (dayl == DayLight.light) {
        return 'src/videobg/clouds_l.mov';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg/clouds_m.mov';
      } else {
        return 'src/videobg/clouds_d.mov';
      }
    } else if ((code >= 600) && (code <= 622)) {
      if (dayl == DayLight.light) {
        return 'src/videobg/snow_l.mov';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg/snow_m.mov';
      } else {
        return 'src/videobg/snow_d.mov';
      }
    } else if ((code >= 500) && (code <= 531)) {
      if (dayl == DayLight.light) {
        return 'src/videobg/rain_l.mov';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg/rain_m.mov';
      } else {
        return 'src/videobg/rain_d.mov';
      }
    } else if ((code >= 300) && (code <= 321)) {
      if (dayl == DayLight.light) {
        return 'src/videobg/cloud_l.mov';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg/cloud_m.mov';
      } else {
        return 'src/videobg/cloud_d.mov';
      }
    } else if ((code >= 200) && (code <= 232)) {
      if (dayl == DayLight.light) {
        return 'src/videobg/storm_l.mov';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg/storm_m.mov';
      } else {
        return 'src/videobg/storm_d.mov';
      }
    } else {
      if (dayl == DayLight.light) {
        return 'src/videobg/sun_l.mov';
      } else if (dayl == DayLight.medium) {
        return 'src/videobg/sun_m.mov';
      } else {
        return 'src/videobg/sun_d.mov';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // return SizedBox();
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: 100 * byWithScale(context),
            child: BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherError) {
                  return Center(child: Text(state.error));
                }
                if (state is WeatherLoaded) {
                  return VideoLayerFittedToWidget(
                      key: Key(
                          getWeatherAssetByCode(state.wCode, state.daylight)),
                      videoAsset:
                          getWeatherAssetByCode(state.wCode, state.daylight),
                      backgroundColor: colorByType(state.daylight));
                }

                return Center(child: Text('Loading'));
              },
            ),
          ),
          Positioned(
            top: 0,
            right: 6 * byWithScale(context),
            child: BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherLoaded) {
                  return Text(state.wTemp,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 46 * byWithScale(context),
                        color: Colors.white,
                      ));
                }
                return SizedBox();
              },
            ),
          )
        ],
      ),
    );
  }
}
