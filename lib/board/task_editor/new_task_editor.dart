import 'dart:async';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/board/models/tasks/supertask.dart';
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/task_editor/color_picker_row.dart';
import 'package:flexible/board/task_editor/deadline_chooser.dart';
import 'package:flexible/board/task_editor/icon_picker_page.dart';
import 'package:flexible/board/task_editor/priority_chooser.dart';
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
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

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
      (BlocProvider.of<SubscribeBloc>(context).state is UnSubscribed);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffE9E9E9),
      body: SafeArea(
          child: SizedBox.expand(
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
                  buildBody(context)
                ]),
              ),
            ],
          ),
        ),
      )),
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
                              BlocProvider.of<DailytasksBloc>(context)
                                  .add(DailytasksAddTask(task: task));
                              Navigator.pop(context);
                            },
                          ),

                          // Remove this screen if user unsubscribed
                          if (!isUnSubscribed())
                            SuperTaskEditorBody(
                              submitChanel: submitS,
                              key: Key('sup'),
                              onSubmit: (task) {
                                print('su ask submit');
                                BlocProvider.of<DailytasksBloc>(context)
                                    .add(DailytasksSuperTaskAdd(task: task));
                                Navigator.pop(context);
                              },
                            ),
                          buildUpdateDeleteButtons()
                        ],
                      ),
                    ),
                    //buildUpdateDeleteButtons()
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

  const RegularTaskEditorBody({
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
              .add(Duration(hours: DateTime.now().hour)),
          period: Duration(),
          isDone: false,
          isDonable: true,
          timeLock: false,
          color: Colors.grey,
          iconId: 'additional');
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
    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => IconPickerPage(),
        )).then((iconId) {
      if (iconId != null) {
        setState(() {
          editableRegularTask = editableRegularTask.copyWith(iconId: iconId);
        });
      }
    });
  }

  Widget typeTaskWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 * byWithScale(context)),
      child: Wrap(
        children: [
          TaskIconInRound(
            iconId: editableRegularTask.iconId,
            taskColor: editableRegularTask.color,
            onTap: () => openImgPicker(),
          ),
          SizedBox(
            width: 20 * byWithScale(context),
          ),
          Container(
            width: byWithScale(context) * 150,
            height: byWithScale(context) * 35,
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        typeTaskWidget(),
        Text(
          'When do you want to do it...',
          style: TextStyle(
              fontSize: 12 * byWithScale(context),
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        Container(
            width: 150 * byWithScale(context),
            height: 100 * byWithScale(context),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: SizedBox(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(15 * byWithScale(context)))),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03,
                        // top: MediaQuery.of(context).size.width * 0.005,
                      ),
                      child: Align(
                        child: Text(
                          ":",
                          style: TextStyle(fontSize: 20),
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    Center(
                      child: TimePickerSpinner(
                        isForce2Digits: true,
                        is24HourMode: true,
                        itemHeight: 30 * byWithScale(context),
                        itemWidth: 30 * byWithScale(context),
                        normalTextStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15 * byWithScale(context)),
                        highlightedTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15 * byWithScale(context)),
                        spacing: 40,
                        minutesInterval: 1,
                        onTimeChange: (time) {
                          setState(() {
                            editableRegularTask =
                                editableRegularTask.copyWith(timeStart: time);
                            //DateTime wakeUpTime =
                            //DateUtils.dateOnly(editableOptions.wakeUpTime).add(time);
                            //_dateTime = time;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
//
            ),
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
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            children: [
              Text(
                'What color should you task be?',
                style: TextStyle(
                    fontSize: 12 * byWithScale(context),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 14 * byWithScale(context)),
              ColorPickerRow(callback: (color) {
                setState(() {
                  editableRegularTask =
                      editableRegularTask.copyWith(color: color);
                });
              }),

            ],
          ),
        ),
        GestureDetector(
//          onTap: () {
//            BlocProvider.of<DailytasksBloc>(context).add(
//                DailytasksUpdateDayOptions(
//                    dayOptions: editableOptions));
//            Navigator.pop(context);
//          },
          child: Container(
            height: 35,
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 70),
            decoration: BoxDecoration(
                color: Color(0xffE24F4F),
                borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Text(
                'CREATE TASK',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ),
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
          globalDuration: Duration(hours: 10),
          globalDurationLeft: Duration(),
          priority: 1);
    }
    onSubmit = widget.submitChanel.listen((event) {
      widget.onSubmit(editableSuperTask);
    });
  }

  openImgPicker() {
    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => IconPickerPage(),
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
          padding: EdgeInsets.symmetric(horizontal: 10 * byWithScale(context)),
          child: Wrap(
            children: [
              TaskIconInRound(
                iconId: editableSuperTask.iconId,
                taskColor: editableSuperTask.color,
                onTap: () => openImgPicker(),
              ),
              SizedBox(
                width: 20 * byWithScale(context),
              ),
              Container(
                width: byWithScale(context) * 150,
                height: byWithScale(context) * 35,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: TitleInputSection(
                  initValue: editableSuperTask.title,
                  onChange: (String text) {
                    setState(() {
                      editableSuperTask =
                          editableSuperTask.copyWith(title: text);
                    });
                  },
                  child: Container(),
                ),
              ),
            ],
          ),
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
              fontSize: 12 * byWithScale(context), fontWeight: FontWeight.w400),
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
              fontSize: 12 * byWithScale(context), fontWeight: FontWeight.w400),
        ),
        SuperTaskDailyDurationSlider(
          duration: editableSuperTask.period,
          onChange: (Duration duration) {
            setState(() {
              editableSuperTask = editableSuperTask.copyWith(period: duration);
            });
          },
        ),
        Wrap(children: [
          Text(
            'Priority:',
            style: TextStyle(
                fontSize: 12 * byWithScale(context),
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          SizedBox(width: 20 * byWithScale(context),),
          PriorityChooser(
            initialPriority: editableSuperTask.priority,
            onChange: (priority) {
              setState(() {
                editableSuperTask =
                    editableSuperTask.copyWith(priority: priority);
              });
            },
          ),
        ],),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            children: [
              Text(
                'What color should you task be?',
                style: TextStyle(
                    fontSize: 12 * byWithScale(context),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 14 * byWithScale(context)),
              ColorPickerRow(callback: (color) {
                setState(() {
                  editableSuperTask =
                      editableSuperTask.copyWith(color: color);
                });
              }),

            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 5),
          child: WideRoundedButton(
              enable: true,
              textColor: Colors.white,
              enableColor: Color(0xffE24F4F),
              disableColor: Color(0xffE24F4F),
              callback: () {},
//              callback: () {
//                if (tasktype == TaskType.Regular) {
//                  onSubmitCR.add('submit');
//                }
//                if (tasktype == TaskType.Super) {
//                  onSubmitCS.add('submit');
//                }
//
//                // BlocProvider.of<DailytasksBloc>(context)
//                //     .add(DailytasksAddTask(task: editableTask));
//                // Navigator.pop(context);
//              },
              text: 'CREATE TASK'),
        ),
      ],
    );
  }
}
