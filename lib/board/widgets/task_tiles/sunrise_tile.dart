import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/weather/bloc/weather_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SunriseTile extends StatefulWidget {
  final VoidCallback callback;
  SunriseTile({
    required this.callback,
  });
  @override
  _SunriseTile createState() => _SunriseTile();
}

class _SunriseTile extends State<SunriseTile> {
  // DateTime currentTime = DateTime.now();
  bool showSubButtons = false;
  bool showWeather = true;

  String geTimeString(DateTime date) => date.toString().substring(11, 16);

  @override
  Widget build(BuildContext context) {
    bool isLessThen350() => MediaQuery.of(context).size.width < 350;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.callback.call();
          // setState(() {
          //   showSubButtons = !showSubButtons;
          // });
        },
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoaded) {
              return Container(
                margin: EdgeInsets.only(top: 16),
                child: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      child: Text(geTimeString(state.sunrise),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10 * byWithScale(context),
                              fontWeight: FontWeight.w400)),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: isLessThen350() ? 40 : 59,
                        ),
                        buildMainIcon(),
                        // SizedBox(
                        //   width: 20,
                        // ),
                        Expanded(
                          child: buildTextSection(time: state.sunrise),
                        ),
                        // buildSubButtons(),
                        SizedBox(
                          width: 25,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }

  Container buildMainIcon() {
    return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Color(0xffE24F4F),
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: Image.asset(
          'src/icons/sunrise.png',
          width: 24,
          height: 24,
          gaplessPlayback: true,
        ));
  }

  Padding buildTextSection({required DateTime time}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '${geTimeString(time)}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12 * byWithScale(context),
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Sunrise',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12 * byWithScale(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
