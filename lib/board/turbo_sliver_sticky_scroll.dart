import 'package:flexible/board/day_options_editor.dart';
import 'package:flexible/board/models/day_options.dart';
import 'package:flexible/board/widgets/sliver_persistant_header.dart';
import 'package:flexible/board/widgets/task_tiles/adding_tile.dart';
import 'package:flexible/board/widgets/task_tiles/morning_tile.dart';
import 'package:flexible/board/widgets/task_tiles/sunrise_tile.dart';
import 'package:flexible/board/widgets/task_tiles/sunset_tile.dart';
import 'package:flexible/board/widgets/task_tiles/system_tile.dart';
import 'package:flexible/utils/modal.dart';
import 'package:flexible/weather/bloc/weather_bloc.dart';
import 'package:flexible/widgets/modals/daily_task_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';

class TurboAnimatedScrollView extends StatefulWidget {
  final List<Widget> tasks;
  final DayOptions dayOptions;

  const TurboAnimatedScrollView({
    Key? key,
    required this.tasks,
    required this.dayOptions,
  }) : super(key: key);

  @override
  _TurboAnimatedScrollViewState createState() =>
      _TurboAnimatedScrollViewState();
}

class _TurboAnimatedScrollViewState extends State<TurboAnimatedScrollView>
    with TickerProviderStateMixin {
  ScrollController scr = ScrollController();
  double topOverscroll = 16;
  double bottomOverscroll = 0;
  double bottomLinePadding = 48;
  GlobalKey morningKey = GlobalKey();
  GlobalKey nightKey = GlobalKey();
  GlobalKey sunsetkey = GlobalKey();
  GlobalKey sunrisekey = GlobalKey();
  bool isSunrise = true;
  bool isSunset = true;
  late AnimationController controller;
  late AnimationController controller2;
  late Animation<double> animation;
  late Animation<double> animation2;

  Rect? _getOffset(GlobalKey? key) {
    if (key == null) return null;
    final renderObject = key.currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      return renderObject?.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    // Calc overscrolls from controller
    // uses for revert bottom bouncing and clip timeline
    scr.addListener(() {
      double negDim = scr.position.pixels - scr.position.maxScrollExtent;

      // 16 is padding over first tile
      if (negDim > -16) {
        setState(() {
          topOverscroll = negDim + 16;
        });
      } else {
        setState(() {
          topOverscroll = 0;
        });
      }

      if (scr.offset < 0) {
        setState(() {
          bottomOverscroll = scr.offset.abs();
        });
      } else {
        setState(() {
          bottomOverscroll = 0;
        });
      }

      if (scr.offset < 32) {
        setState(() {
          bottomLinePadding = scr.offset.abs() + 45;
        });
      } else {
        setState(() {
          bottomLinePadding = 0;
        });
      }
    });
    controller = new AnimationController(
        duration: Duration(milliseconds: 300), vsync: this)
      ..addListener(() => setState(() {}));
    controller2 = new AnimationController(
        duration: Duration(milliseconds: 300), vsync: this)
      ..addListener(() => setState(() {}));
    animation = Tween(begin: 0.0, end: 550.0).animate(controller);
    animation2 = Tween(begin: 0.0, end: 550.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TurboAnimatedScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tasks.length != widget.tasks.length) {
      topOverscroll = 16;
      bottomLinePadding = 48;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLessThen350() => MediaQuery.of(context).size.width < 350;
    return SizedBox(
      child: Stack(
        children: [
          // This is line under widgets
          // Its size grows with list size
          Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(
                    left: isLessThen350() ? 64 : 82,
                    top: topOverscroll,
                    bottom: bottomLinePadding),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(width: 2, color: Colors.white)),
              )),
          // The sliver
          CustomScrollView(
            cacheExtent: 200,
            controller: scr,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            reverse: true,
            slivers: <Widget>[
              // Fake space
              // Need to simulate bouncing like on dafault listview
              SliverPersistentHeader(
                  pinned: false,
                  floating: false,
                  delegate: SliverPersisHeader(
                      minExtent: 0,
                      maxExtent: bottomOverscroll,
                      child: SizedBox())),
              // Good night
              buildGoonNightAndSunset(context),
              // Adding section with last tile
              // grows up when main sliver is fully scrolled
              SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: SliverPersisHeader(
                    minExtent: 80,
                    maxExtent: 80,
                    child: AddingTile(),
                  )),
              // Main sliver
              SliverClip(
                child: SliverList(
                    delegate: SliverChildListDelegate(
                        widget.tasks.reversed.toList())),
              ),
              // Good morning
              buildMorningAndSunrise(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildGoonNightAndSunset(BuildContext context) {
    List<Widget> w = [
      SystemTile(
          key: nightKey,
          showTime: widget.dayOptions.goToSleepTime,
          title: 'Good night',
          subtitle: 'Sleep well',
          image: Image.asset(
            'src/task_icons/goodnight.png',
            scale: 1.1,
          ),
          callback: () {
            showModal(
                context,
                DailyTaskModal(
                    widget.dayOptions, _getOffset(nightKey)?.top ?? 0, () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            DayOptionsEditor(dayOptions: widget.dayOptions),
                      ));
                }, 'Edit'));
          }),
      Builder(
        builder: (BuildContext context) {
          if (isSunset) {
            return Transform.translate(
              offset: Offset(animation2.value, 0.0),

              child: SusetTile(
                  key: sunsetkey,
                  callback: () {
                    showModal(
                        context,
                        DailyTaskModal(
                            widget.dayOptions,
                            _getOffset(sunsetkey)?.top ?? 250,
                                () {
                              controller2.forward();
                              Future.delayed(
                                Duration(milliseconds: 300), () {
                                setState(() {
                                  isSunset = !isSunset;
                                });
                              },
                              );
                            }, "Disable"));
                  }),
            );
          } else {
            return Container();
          }
        },
      )
      // Check if disabled
    ];

    // Reverse position of goodnight and sunset by time
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoaded) {
          DateTime sleepTime = DateTime(
              2017,
              9,
              7,
              widget.dayOptions.goToSleepTime.hour,
              widget.dayOptions.goToSleepTime.minute);
          DateTime sunset =
          DateTime(2017, 9, 7, state.sunset.hour, state.sunset.minute);
          if (state is WeatherLoaded &&
              sleepTime
                  .difference(sunset)
                  .isNegative &&
              !(sleepTime
                  .difference(DateUtils.dateOnly(sleepTime))
                  .inMinutes <
                  30)) {
            w = w.reversed.toList();
          }
        }

        return SliverList(delegate: SliverChildListDelegate(w));
      },
    );
  }

  Widget buildMorningAndSunrise(BuildContext context) {
    List<Widget> w = [
      MorningTile(
          key: morningKey,
          showTime: widget.dayOptions.wakeUpTime,
          title: 'Good morning',
          subtitle: 'Have a nice day',
          image: Image.asset(
            'src/task_icons/morning.png',
            scale: 1.1,
          ),
          callback: () {
            showModal(
                context,
                DailyTaskModal(
                    widget.dayOptions, _getOffset(morningKey)?.top ?? 0, () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            DayOptionsEditor(dayOptions: widget.dayOptions),
                      ));
                }, 'Edit'));
          }),
      // Check if disabled
      Builder(
        builder: (BuildContext context) {
          if (isSunrise) {
            return Transform.translate(
              offset: Offset(animation.value, 0.0),

              child: SunriseTile(
                  key: sunrisekey,
                  callback: () {
                    showModal(
                        context,
                        DailyTaskModal(
                            widget.dayOptions,
                            _getOffset(sunrisekey)?.top ?? 250,
                                () {
                              controller.forward();
                              Future.delayed(
                                Duration(milliseconds: 300), () {
                                setState(() {
                                  isSunrise = !isSunrise;
                                });
                              },
                              );
                            }, "Disable"));
                  }),
            );
          } else {
            return Container();
          }
        },
      )
    ];

    // Reverse position of morning and sunrise by time
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoaded) {
          DateTime wakeupTime = DateTime(
              2017,
              9,
              7,
              widget.dayOptions.wakeUpTime.hour,
              widget.dayOptions.wakeUpTime.minute);
          DateTime sunrise =
          DateTime(2017, 9, 7, state.sunrise.hour, state.sunrise.minute);

          if (state is WeatherLoaded &&
              wakeupTime
                  .difference(sunrise)
                  .isNegative) {
            w = w.reversed.toList();
          }
        }

        return SliverList(delegate: SliverChildListDelegate(w));
      },
    );
  }
}
