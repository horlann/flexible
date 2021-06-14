import 'dart:async';

import 'package:flexible/board/task_editor/priority_chooser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/board/models/tasks/supertask.dart';
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/task_editor/color_picker_row.dart';
import 'package:flexible/board/task_editor/deadline_chooser.dart';
import 'package:flexible/board/task_editor/icon_picker_page.dart';
import 'package:flexible/board/task_editor/row_with_close_btn.dart';
import 'package:flexible/board/task_editor/supertask_daily_duration_slider.dart';
import 'package:flexible/board/task_editor/supertask_global_duration_slider.dart';
import 'package:flexible/board/task_editor/task_icon_in_round.dart';
import 'package:flexible/board/task_editor/task_period_slider.dart';
import 'package:flexible/board/task_editor/time_picker.dart';
import 'package:flexible/board/task_editor/title_input_section.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';

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
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: buildBody(context),
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
            padding: EdgeInsets.all(16 * byWithScale(context)),
            // Stack uses for make layer of glass
            child: Stack(
              children: [
                // the glass layer
                // fill uses for adopt is size
                Positioned.fill(child: GlassmorphLayer()),
                Column(
                  children: [
                    RowWithCloseBtn(context: context),
                    Text(
                      'Create Task',
                      style: TextStyle(
                        fontSize: 24 * byWithScale(context),
                        fontWeight: FontWeight.w700,
                        color: Color(0xffE24F4F),
                      ),
                    ),
                    buildTaskTypeSwitcher(context),
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
                            onSubmit: (task) {
                              BlocProvider.of<DailytasksBloc>(context)
                                  .add(DailytasksAddTask(task: task));
                              Navigator.pop(context);
                            },
                          ),
                          SuperTaskEditorBody(
                            submitChanel: submitS,
                            onSubmit: (task) {
                              BlocProvider.of<DailytasksBloc>(context)
                                  .add(DailytasksAddTask(task: task));
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        buildUpdateDeleteButtons()
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
                                width: 4, color: Color(0xffE24F4F)))),
                child: Text(
                  'Regular task',
                  style: TextStyle(
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
                                width: 4, color: Color(0xffE24F4F)))),
                child: Text(
                  'Super task',
                  style: TextStyle(
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
          padding: EdgeInsets.symmetric(horizontal: 40),
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

                // BlocProvider.of<DailytasksBloc>(context)
                //     .add(DailytasksAddTask(task: editableTask));
                // Navigator.pop(context);
              },
              text: 'Create Task'),
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

    widget.submitChanel.listen((event) {
      widget.onSubmit(editableRegularTask);
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
          editableRegularTask = editableRegularTask.copyWith(iconId: iconId);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TitleInputSection(
          initValue: editableRegularTask.title,
          onChange: (String text) {
            setState(() {
              editableRegularTask = editableRegularTask.copyWith(title: text);
            });
          },
          child: TaskIconInRound(
            iconId: editableRegularTask.iconId,
            taskColor: editableRegularTask.color,
            onTap: () => openImgPicker(),
          ),
        ),
        Text(
          'When do you want to do it...',
          style: TextStyle(
              fontSize: 12 * byWithScale(context), fontWeight: FontWeight.w600),
        ),
        TimePicker(
          timeStart: editableRegularTask.timeStart,
          callback: (time) {
            setState(() {
              editableRegularTask =
                  editableRegularTask.copyWith(timeStart: time);
            });
          },
        ),
        Text(
          '...once on ${editableRegularTask.timeStart.toString().substring(0, 10)}',
          style: TextStyle(
              fontSize: 10 * byWithScale(context), fontWeight: FontWeight.w400),
        ),
        Text(
          '...and how long it will take',
          style: TextStyle(
              fontSize: 10 * byWithScale(context), fontWeight: FontWeight.w400),
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
        Text(
          'What color should you task be?',
          style: TextStyle(
              fontSize: 12 * byWithScale(context), fontWeight: FontWeight.w600),
        ),
        ColorPickerRow(callback: (color) {
          setState(() {
            editableRegularTask = editableRegularTask.copyWith(color: color);
          });
        }),
      ],
    );
  }
}

class SuperTaskEditorBody extends StatefulWidget {
  final SuperTask? task;
  final Stream submitChanel;
  final Function(Task task) onSubmit;
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
    widget.submitChanel.listen((event) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TitleInputSection(
          initValue: editableSuperTask.title,
          onChange: (String text) {
            setState(() {
              editableSuperTask = editableSuperTask.copyWith(title: text);
            });
          },
          child: TaskIconInRound(
            iconId: editableSuperTask.iconId,
            taskColor: editableSuperTask.color,
            onTap: () => openImgPicker(),
          ),
        ),
        Text(
          'Choose deadline of your Supertask',
          style: TextStyle(
              fontSize: 12 * byWithScale(context), fontWeight: FontWeight.w600),
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
          'What is your task Duration',
          style: TextStyle(
              fontSize: 12 * byWithScale(context), fontWeight: FontWeight.w600),
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
              fontSize: 12 * byWithScale(context), fontWeight: FontWeight.w600),
        ),
        SuperTaskDailyDurationSlider(
          duration: editableSuperTask.period,
          onChange: (Duration duration) {
            setState(() {
              editableSuperTask = editableSuperTask.copyWith(period: duration);
            });
          },
        ),
        Text(
          'Priority',
          style: TextStyle(
              fontSize: 12 * byWithScale(context), fontWeight: FontWeight.w600),
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
        ColorPickerRow(callback: (color) {
          setState(() {
            editableSuperTask = editableSuperTask.copyWith(color: color);
          });
        }),
      ],
    );
  }
}
