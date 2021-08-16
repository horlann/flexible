import 'dart:async';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/board/models/tasks/supertask.dart';
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/task_editor/color_picker_row.dart';
import 'package:flexible/board/task_editor/deadline_chooser.dart';
import 'package:flexible/board/task_editor/icon_picker_page.dart';
import 'package:flexible/board/task_editor/ogtimepicker.dart';
import 'package:flexible/board/task_editor/priority_chooser.dart';
import 'package:flexible/board/task_editor/routes.dart';
import 'package:flexible/board/task_editor/row_with_close_btn.dart';
import 'package:flexible/board/task_editor/supertask_daily_duration_slider.dart';
import 'package:flexible/board/task_editor/supertask_global_duration_slider.dart';
import 'package:flexible/board/task_editor/task_icon_in_round.dart';
import 'package:flexible/board/task_editor/task_period_slider.dart';
import 'package:flexible/board/task_editor/title_input_section.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/board/widgets/weather_bg.dart';
import 'package:flexible/subscription/bloc/subscribe_bloc.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/widgets/flush.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum TaskType { Regular, Super }

class NewTaskEditor extends StatefulWidget {
  @override
  _NewTaskEditorState createState() => _NewTaskEditorState();
}

class _NewTaskEditorState extends State<NewTaskEditor> {
  PageController _pageController = PageController();
  TaskType tasktype = TaskType.Regular;
  StreamController onSubmitCR = StreamController();
  late Stream submitR;
  StreamController onSubmitCS = StreamController();
  late Stream submitS;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey key = GlobalKey();

  final List<Duration> durations = [
    Duration(minutes: 30),
    Duration(hours: 1),
    Duration(hours: 2),
    Duration(hours: 3),
    Duration(hours: 4),
    Duration(hours: 5),
    Duration(hours: 3),
    Duration(hours: 4),
    Duration(hours: 5),
    Duration(hours: 5),
  ];
  final List<Duration> durations2 = [
    Duration(minutes: 30),
    Duration(hours: 1),
    Duration(hours: 2),
    Duration(hours: 3),
    Duration(hours: 4),
    Duration(hours: 5),
    Duration(hours: 3),
    Duration(hours: 4),
    Duration(hours: 5),
    Duration(hours: 5),
  ];

  @override
  void initState() {
    super.initState();
    submitR = onSubmitCR.stream.asBroadcastStream();
    submitS = onSubmitCS.stream.asBroadcastStream();
  }

  @override
  void dispose() {
    super.dispose();
    onSubmitCR.close();
    onSubmitCS.close();
  }

  setTaskType(TaskType type) {
    setState(() {
      tasktype = type;
    });
    _pageController.animateToPage(type == TaskType.Regular ? 0 : 1,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  bool isUnSubscribed() =>
      (BlocProvider.of<SubscribeBloc>(context).state is! Subscribed);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Color(0xffE9E9E9),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: mainBackgroundGradient,
          ),
          child: CustomScrollView(
            shrinkWrap: true,
            primary: false,
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Stack(children: [
                  Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: WeatherBg(),
                  ),
                  SafeArea(child: buildBody(context))
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16 * byWithScale(context),
                vertical: 8 * byWithScale(context)),
            // Stack uses for make layer of glass
            child: Stack(
              children: [
                // the glass layer
                // fill uses for adopt is size
                Positioned.fill(child: GlassmorphLayer()),
                RowWithCloseBtn(context: context),

                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15 * byWithScale(context)),
                      child: Text(
                        'Create  a Task',
                        style: TextStyle(
                          fontSize: 24 * byWithScale(context),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10 * byWithScale(context),
                    ),
                    isUnSubscribed()
                        ? SizedBox()
                        : buildTaskTypeSwitcher(context),
                    Expanded(
                      child: PageView(
                        onPageChanged: (value) {
                          value == 1
                              ? setTaskType(TaskType.Super)
                              : setTaskType(TaskType.Regular);
                        },
                        controller: _pageController,
                        children: [
                          RegularTaskEditorBody(
                            submitChanel: submitR,
                            key: Key('reg'),
                            onSubmit: (task) {
                              print('reg ask submit');
                              print(task.title.isEmpty);

                              if (task.title.isEmpty) {
                                showFlush(context,
                                    'Task title shouldn\'t be empty', false)
                                  ..show(context);
                              } else {
                                BlocProvider.of<DailytasksBloc>(context)
                                    .add(DailytasksAddTask(task: task));
                                Navigator.pop(context);
                              }
                            },
                          ),

                          // Remove this screen if user unsubscribed
                          if (!isUnSubscribed())
                            SuperTaskEditorBody(
                              submitChanel: submitS,
                              key: Key('sup'),
                              onSubmit: (task) {
                                if (task.title.isEmpty) {
                                  showFlush(context,
                                      'Task title shouldn\'t be empty', false)
                                    ..show(context);
                                } else {
                                  print('su ask submit');
                                  BlocProvider.of<DailytasksBloc>(context)
                                      .add(DailytasksSuperTaskAdd(task: task));
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          //buildUpdateDeleteButtons()
                        ],
                      ),
                    ),
                    buildUpdateDeleteButtons()
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTaskTypeSwitcher(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setTaskType(TaskType.Regular),
            child: Container(
                decoration: tasktype != TaskType.Regular
                    ? null
                    : BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                        width: 1,
                        color: Colors.white,
                      ))),
                child: Text(
                  'Regular task',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12 * byWithScale(context),
                      fontWeight: tasktype != TaskType.Regular
                          ? FontWeight.w400
                          : FontWeight.w600),
                )),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setTaskType(TaskType.Super),
            child: Container(
                decoration: tasktype != TaskType.Super
                    ? null
                    : BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                        width: 1,
                        color: Colors.white,
                      ))),
                child: Text(
                  'Super task',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12 * byWithScale(context),
                      fontWeight: tasktype != TaskType.Super
                          ? FontWeight.w400
                          : FontWeight.w600),
                )),
          ),
        ),
      ],
    );
  }

  // Sends edited task to bloc
  Widget buildUpdateDeleteButtons() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
          child: WideRoundedButton(
              enable: true,
              textColor: Colors.white,
              enableColor: Color(0xffE24F4F),
              disableColor: Color(0xffE24F4F),
              callback: () {
                if (tasktype == TaskType.Regular) {
                  onSubmitCR.add('submit');
                }
                if (tasktype == TaskType.Super) {
                  onSubmitCS.add('submit');
                }

//                 BlocProvider.of<DailytasksBloc>(context)
//                     .add(DailytasksAddTask(task: editableTask));
//                 Navigator.pop(context);
              },
              text: 'CREATE TASK'),
        ),
        SizedBox(
          height: 8 * byWithScale(context),
        ),
      ],
    );
  }
}

class RegularTaskEditorBody extends StatefulWidget {
  final RegularTask? task;
  final Stream submitChanel;
  final Function(Task task) onSubmit;
  final GlobalKey keyy = GlobalKey();

  RegularTaskEditorBody({
    Key? key,
    this.task,
    required this.submitChanel,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _RegularTaskEditorBodyState createState() => _RegularTaskEditorBodyState();
}

class _RegularTaskEditorBodyState extends State<RegularTaskEditorBody> {
  late RegularTask editableRegularTask;
  late StreamSubscription onSubmit;

  @override
  void initState() {
    super.initState();

    // Create new task if task not passed
    if (widget.task != null) {
      editableRegularTask = widget.task!;
    } else {
      editableRegularTask = RegularTask(
          title: '',
          subtitle: '',
          timeStart: DateUtils.dateOnly(
                  BlocProvider.of<DailytasksBloc>(context).state.showDay)
              .add(Duration(
                  hours: DateTime.now().hour, minutes: DateTime.now().minute)),
          period: Duration(hours: 0),
          isDone: false,
          isDonable: true,
          timeLock: false,
          color: Colors.grey,
          iconId: 'additional',
          superTaskId: "");
    }

    onSubmit = widget.submitChanel.listen((event) {
      widget.onSubmit(editableRegularTask);
    });
  }

  dispose() {
    super.dispose();
    onSubmit.cancel();
    print('Reg task creator dispose');
  }

  openImgPicker() {
    print(_getOffset(widget.keyy));
    Navigator.push(
        context,
        RevealRoute(
          page: IconPickerPage(
            text: editableRegularTask.title,
          ),
          maxRadius: 800,
          centerAlignment: Alignment.center,
          centerOffset: _getOffset(widget.keyy),
        )).then((iconId) {
      if (iconId != null) {
        setState(() {
          editableRegularTask = editableRegularTask.copyWith(iconId: iconId);
        });
      }
    });
  }

  Offset? _getOffset(GlobalKey? key) {
    if (key == null) return null;
    final renderObject = key.currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    print(Offset(translation!.x, translation.y).toString());

    if (translation != null && renderObject?.paintBounds != null) {
      return Offset(translation.x, translation.y);
    } else {
      return null;
    }
  }

  Widget typeTaskWidget() {
    int c = 0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 * byWithScale(context)),
      child: Row(
        children: [
          GestureDetector(
            onDoubleTap: () {
              c++;
              print(c);
              if (c == 3) {
                print('Marked as ai suitable');
                showFlush(context, 'Marked as ai suitable', false)
                    .show(context);
              }
              editableRegularTask = editableRegularTask.copyWith(forAi: true);
              print(editableRegularTask.forAi);
            },
            child: TaskIconInRound(
              key: widget.keyy,
              iconId: editableRegularTask.iconId,
              taskColor: editableRegularTask.color,
              onTap: () => openImgPicker(),
            ),
          ),
          SizedBox(
            width: 20 * byWithScale(context),
          ),
          Expanded(
            child: Container(
              //width: byWithScale(context) * 150,
              //height: byWithScale(context) * 35,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: TitleInputSection(
                initValue: editableRegularTask.title,

                onChange: (String text) {
                  setState(() {
                    editableRegularTask =
                        editableRegularTask.copyWith(title: text);
                  });
                },
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(editableRegularTask.timeStart.toString() + "   time");
    int i = 0;
    return Column(
      //mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32 / pRatio(context)),
          child: typeTaskWidget(),
        ),
        Text(
          'When do you want to do it...',
          style: TextStyle(
              fontSize: 48 / pRatio(context),
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        GestureDetector(
          onHorizontalDragDown: (details) {},
          child: OgTimePicker(
            initTime: editableRegularTask.timeStart,
            onChange: (time) {
              editableRegularTask = editableRegularTask.copyWith(
                  timeStart:
                      time.add(Duration(milliseconds: Random().nextInt(100))));
            },
          ),
        ),
        // GestureDetector(
        //   // behavior: HitTestBehavior.opaque,
        //   onHorizontalDragStart: (details) {
        //     print('h');
        //   },
        //   child: Container(
        //     margin: EdgeInsets.symmetric(horizontal: 40 * byWithScale(context)),
        //     padding: EdgeInsets.symmetric(vertical: 10 * byWithScale(context)),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.all(
        //         Radius.circular(
        //           15 * byWithScale(context),
        //         ),
        //       ),
        //     ),
        //     child: Stack(
        //       children: [
        //         Positioned.fill(
        //           child: Align(
        //             child: Text(
        //               ":",
        //               style: TextStyle(fontSize: 20),
        //             ),
        //             alignment: Alignment.center,
        //           ),
        //         ),
        //         TimePickerSpinner(
        //           alignment: Alignment.center,
        //           isForce2Digits: true,
        //           is24HourMode: true,
        //           itemHeight: 30 * byWithScale(context),
        //           itemWidth: 60 * byWithScale(context),
        //           normalTextStyle: TextStyle(
        //               color: Colors.grey, fontSize: 55 / pRatio(context)),
        //           highlightedTextStyle: TextStyle(
        //               color: Colors.black, fontSize: 55 / pRatio(context)),
        //           spacing: 0,
        //           minutesInterval: 1,
        //           time: editableRegularTask.timeStart,
        //           onTimeChange: (time) {
        //             setState(() {
        //               editableRegularTask = editableRegularTask.copyWith(
        //                   timeStart: time.add(
        //                       Duration(milliseconds: Random().nextInt(100))));
        //             });
        //           },
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        Wrap(
          children: [
            Text(
              '...once ',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Color(0xffE24F4F),
                  fontSize: 10 * byWithScale(context),
                  fontWeight: FontWeight.w400),
            ),
            Text(
              'on ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10 * byWithScale(context),
                  fontWeight: FontWeight.w400),
            ),
            Text(
              '${editableRegularTask.timeStart.toString().substring(0, 10)}',
              style: TextStyle(
                  color: Color(0xffE24F4F),
                  fontSize: 10 * byWithScale(context),
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        Text(
          '...and how long it will take',
          style: TextStyle(
              color: Colors.white,
              fontSize: 10 * byWithScale(context),
              fontWeight: FontWeight.w400),
        ),
        TaskPeriodSlider(
          period: editableRegularTask.period,
          callback: (Duration newPeriod) {
            setState(() {
              editableRegularTask =
                  editableRegularTask.copyWith(period: newPeriod);
            });
          },
        ),
        SizedBox(
          height: 10 * byWithScale(context),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16 * byWithScale(context)),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          padding: EdgeInsets.symmetric(
              horizontal: 5, vertical: 8 * byWithScale(context)),
          child: Column(
            children: [
              Text(
                'What color should you task be?',
                style: TextStyle(
                    fontSize: 12 * byWithScale(context),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10 * byWithScale(context)),
              ColorPickerRow(callback: (color) {
                setState(() {
                  editableRegularTask =
                      editableRegularTask.copyWith(color: color);
                  //i=pos;
                });
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class SuperTaskEditorBody extends StatefulWidget {
  final SuperTask? task;
  final Stream submitChanel;
  final Function(SuperTask task) onSubmit;

  const SuperTaskEditorBody({
    Key? key,
    this.task,
    required this.submitChanel,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _SuperTaskEditorBodyState createState() => _SuperTaskEditorBodyState();
}

class _SuperTaskEditorBodyState extends State<SuperTaskEditorBody> {
  late SuperTask editableSuperTask;
  late StreamSubscription onSubmit;

  @override
  void initState() {
    super.initState();

    // Create new task if task not passed
    if (widget.task != null) {
      editableSuperTask = widget.task!;
    } else {
      editableSuperTask = SuperTask(
          title: '',
          subtitle: '',
          timeStart: DateUtils.dateOnly(
                  BlocProvider.of<DailytasksBloc>(context).state.showDay)
              .add(Duration(hours: DateTime.now().hour)),
          period: Duration(hours: 1),
          isDone: false,
          isDonable: true,
          timeLock: false,
          color: Colors.grey,
          iconId: 'additional',
          deadline: BlocProvider.of<DailytasksBloc>(context)
              .state
              .showDay
              .add(Duration(days: 7)),
          globalDuration: Duration(hours: 1),
          globalDurationLeft: Duration(),
          priority: 1,
          superTaskId: "");
    }
    onSubmit = widget.submitChanel.listen((event) {
      widget.onSubmit(editableSuperTask);
    });
  }

  openImgPicker() {
    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => IconPickerPage(
            text: editableSuperTask.title,
          ),
        )).then((iconId) {
      if (iconId != null) {
        setState(() {
          editableSuperTask = editableSuperTask.copyWith(iconId: iconId);
        });
      }
    });
  }

  dispose() {
    super.dispose();
    onSubmit.cancel();
    print('Sup task creator dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32 / pRatio(context)),
          child: typeTaskWidget(),
        ),
        Text(
          'Choose deadline of your Supertask',
          style: TextStyle(
              fontSize: 12 * byWithScale(context),
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
        DeadLineChooser(
          initialDeadline: editableSuperTask.deadline,
          timeStart: editableSuperTask.timeStart,
          onChange: (date) {
            setState(() {
              editableSuperTask = editableSuperTask.copyWith(deadline: date);
            });
          },
        ),
        Text(
          'What is your task Duration?',
          style: TextStyle(
              color: Colors.white,
              fontSize: 12 * byWithScale(context),
              fontWeight: FontWeight.w400),
        ),
        SuperTaskGlobasDurationSlider(
          duration: editableSuperTask.globalDuration,
          onChange: (Duration duration) {
            setState(() {
              editableSuperTask =
                  editableSuperTask.copyWith(globalDuration: duration);
            });
          },
        ),
        Text(
          'Daily Task Time?',
          style: TextStyle(
              color: Colors.white,
              fontSize: 12 * byWithScale(context),
              fontWeight: FontWeight.w400),
        ),
        SuperTaskDailyDurationSlider(
          duration: editableSuperTask.period,
          onChange: (Duration duration) {
            setState(() {
              editableSuperTask = editableSuperTask.copyWith(period: duration);
            });
          },
        ),
        Wrap(
          children: [
            Text(
              'Priority:',
              style: TextStyle(
                  fontSize: 12 * byWithScale(context),
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            SizedBox(
              width: 20 * byWithScale(context),
            ),
            PriorityChooser(
              initialPriority: editableSuperTask.priority,
              onChange: (priority) {
                setState(() {
                  editableSuperTask =
                      editableSuperTask.copyWith(priority: priority);
                });
              },
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16 * byWithScale(context)),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          padding: EdgeInsets.symmetric(
              horizontal: 5, vertical: 8 * byWithScale(context)),
          child: Column(
            children: [
              Text(
                'What color should you task be?',
                style: TextStyle(
                    fontSize: 12 * byWithScale(context),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20 * byWithScale(context)),
              ColorPickerRow(callback: (color) {
                setState(() {
                  editableSuperTask = editableSuperTask.copyWith(color: color);
                });
              }),
              SizedBox(height: 20 * byWithScale(context)),
            ],
          ),
        ),
      ],
    );
  }

  Widget typeTaskWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 * byWithScale(context)),
      child: Row(
        children: [
          TaskIconInRound(
            iconId: editableSuperTask.iconId,
            taskColor: editableSuperTask.color,
            onTap: () => openImgPicker(),
          ),
          SizedBox(
            width: 20 * byWithScale(context),
          ),
          Expanded(
            child: Container(
              // width: byWithScale(context) * 150,
              // height: byWithScale(context) * 35,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: TitleInputSection(
                initValue: editableSuperTask.title,
                onChange: (String text) {
                  setState(() {
                    editableSuperTask = editableSuperTask.copyWith(title: text);
                  });
                },
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
