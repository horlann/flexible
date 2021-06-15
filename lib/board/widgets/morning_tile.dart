import 'package:flexible/board/weather_widget.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/weather/bloc/weather_bloc.dart';
import 'package:flexible/weather/openweather_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invert_colors/invert_colors.dart';

class MorningTile extends StatefulWidget {
  final DateTime showTime;
  final String title;
  final String subtitle;
  final Image image;
  final VoidCallback callback;
  MorningTile({
    Key? key,
    required this.showTime,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.callback,
  }) : super(key: key);
  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<MorningTile> {
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
          setState(() {
            showSubButtons = !showSubButtons;
          });
        },
        child: Container(
          margin: EdgeInsets.only(top: 16),
          child: Stack(
            children: [
              Positioned(
                  top: 16,
                  child: BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) {
                      if (state is WeatherLoaded) {
                        return Text(geTimeString(widget.showTime),
                            style: TextStyle(
                                color: state.daylight == DayLight.dark
                                    ? Colors.white
                                    : Color(0xff545353),
                                fontSize: 10 * byWithScale(context),
                                fontWeight: FontWeight.w400));
                      }
                      return Text(geTimeString(widget.showTime),
                          style: TextStyle(
                              color: Color(0xff545353),
                              fontSize: 10 * byWithScale(context),
                              fontWeight: FontWeight.w400));
                    },
                  )),
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
                    child: buildTextSection(),
                  ),
                  // buildSubButtons(),
                  SizedBox(
                    width: 25,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildMainIcon() {
    return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color(0xffEE7579), blurRadius: 20, offset: Offset(0, 10))
          ],
          color: Color(0xffEE7579),
          borderRadius: BorderRadius.circular(25),
        ),
        child: InvertColors(child: widget.image));
  }

  Column buildTextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  return Text(
                    '${geTimeString(widget.showTime)}',
                    style: TextStyle(
                        color: state.daylight == DayLight.dark
                            ? Colors.white
                            : Color(0xff545353),
                        fontSize: 14 * byWithScale(context),
                        fontWeight: FontWeight.w400),
                  );
                },
              ),
            ),
            buildSubButtons(),
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  return Text(
                    widget.title,
                    style: TextStyle(
                      color: state.daylight == DayLight.dark
                          ? Colors.white
                          : Color(0xff545353),
                      fontSize: 14 * byWithScale(context),
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ),
            ),
            showSubButtons
                ? InkWell(
                    child: showWeather
                        ? Icon(Icons.close)
                        : Icon(Icons.add_rounded),
                    onTap: () {
                      setState(() {
                        showWeather = !showWeather;
                      });
                    },
                  )
                : SizedBox(),
          ],
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 20),
        //   child: Text(
        //     widget.subtitle,
        //     style: TextStyle(
        //         color: Color(0xff545353),
        //         fontSize: 12 * byWithScale(context),
        //         fontWeight: FontWeight.w400),
        //   ),
        // ),
        SizedBox(
          height: 4,
        ),
        AnimatedCrossFade(
            firstChild: SizedBox(),
            secondChild: WeatherWidget(),
            crossFadeState: !showWeather
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 200)),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  // Button under task
  // Shows when user tap on task tile
  Widget buildSubButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: AnimatedCrossFade(
        duration: Duration(milliseconds: 200),
        crossFadeState: showSubButtons
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: SizedBox(),
        secondChild: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            miniButton(
                text: 'Edit Time',
                iconAsset: 'src/icons/edit.png',
                callback: () => widget.callback()),
          ],
        ),
      ),
    );
  }

  Widget miniButton(
      {required String text,
      required String iconAsset,
      VoidCallback? callback}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (callback != null) {
            callback();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xff4077C1).withOpacity(0.75),
            borderRadius: BorderRadius.circular(16),
            // border: Border.all(color: Color(0xffF66868), width: 2),
          ),
          child: Row(
            children: [
              Image.asset(
                iconAsset,
                width: 16,
                height: 16,
                // fit: BoxFit.cover,
              ),
              // SizedBox(
              //   width: 2,
              // ),
              // Text(
              //   text,
              //   style: TextStyle(fontSize: 8, color: Colors.white),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
