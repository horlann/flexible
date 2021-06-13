import 'package:flexible/board/models/tasks/supertask.dart';
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/task_editor/color_picker_row.dart';
import 'package:flexible/board/task_editor/icon_picker_page.dart';
import 'package:flexible/board/task_editor/row_with_close_btn.dart';
import 'package:flexible/board/task_editor/task_icon_in_round.dart';
import 'package:flexible/board/task_editor/time_slider.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';

enum TaskType { Regular, Super }

class NewTaskEditor extends StatefulWidget {
  @override
  _NewTaskEditorState createState() => _NewTaskEditorState();
}

class _NewTaskEditorState extends State<NewTaskEditor> {
  PageController _pageController = PageController();
  TaskType tasktype = TaskType.Regular;

  late RegularTask editableRegularTask;
  late SuperTask editableSuperTask;

  @override
  void initState() {
    super.initState();
    // Create New Task
    createEditableTask();
  }

  // Create new task for edit
  createEditableTask() {
    setState(() {
      editableRegularTask = RegularTask(
          title: 'New Task',
          subtitle: '',
          timeStart: BlocProvider.of<DailytasksBloc>(context).state.showDay,
          period: Duration(),
          isDone: false,
          isDonable: true,
          timeLock: false,
          color: Colors.grey,
          iconId: 'additional');
      editableSuperTask = SuperTask(
          title: 'New Task',
          subtitle: '',
          timeStart: BlocProvider.of<DailytasksBloc>(context).state.showDay,
          period: Duration(),
          isDone: false,
          isDonable: true,
          timeLock: false,
          color: Colors.grey,
          iconId: 'additional',
          deadline: BlocProvider.of<DailytasksBloc>(context)
              .state
              .showDay
              .add(Duration(days: 7)),
          globalDuration: Duration(days: 30),
          globalDurationLeft: Duration(),
          priority: 1);
    });
  }

  setTaskType(TaskType type) {
    setState(() {
      tasktype = type;
    });
    _pageController.animateToPage(type == TaskType.Regular ? 0 : 1,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  // Open picker
  // Picker should return icon id as string
  openImgPicker() {
    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => IconPickerPage(),
        )).then((iconId) {
      if (iconId != null) {
        setState(() {
          editableRegularTask = editableRegularTask.copyWith(iconId: iconId);
          editableSuperTask = editableSuperTask.copyWith(iconId: iconId);
        });
      }
    });
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
                          RegularTaskEditorBody(context: context),
                          // SuperTaskEditorBody(context: context)
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
                // BlocProvider.of<DailytasksBloc>(context)
                //     .add(DailytasksAddTask(task: editableTask));
                Navigator.pop(context);
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

class RegularTaskEditorBody extends StatelessWidget {
  const RegularTaskEditorBody({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildTitleInputSection(),
        Text(
          'When do you want to do it...',
          style: TextStyle(
              fontSize: 12 * byWithScale(context), fontWeight: FontWeight.w600),
        ),
        buildTimePicker(),
        Text(
          '...once on ${editableTask.timeStart.toString().substring(0, 10)}',
          style: TextStyle(
              fontSize: 10 * byWithScale(context), fontWeight: FontWeight.w400),
        ),
        Text(
          '...and how long it will take',
          style: TextStyle(
              fontSize: 10 * byWithScale(context), fontWeight: FontWeight.w400),
        ),
        TimeSlider(
          period: editableTask.period,
          callback: (Duration newPeriod) {
            setState(() {
              editableTask = editableTask.copyWith(period: newPeriod);
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
            editableTask = editableTask.copyWith(color: color);
          });
        }),
      ],
    );
  }
}

// class SuperTaskEditorBody extends StatelessWidget {
//   const SuperTaskEditorBody({
//     Key? key,
//     required this.context,
//   }) : super(key: key);

//   final BuildContext context;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         buildTitleInputSection(),
//         Text(
//           'Choose deadline of your Supertask',
//           style: TextStyle(
//               fontSize: 12 * byWithScale(context), fontWeight: FontWeight.w600),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             GestureDetector(
//               onTap: () => ,
//                           child: Container(
//                 padding: EdgeInsets.symmetric(
//                     vertical: 4 * byWithScale(context),
//                     horizontal: 6 * byWithScale(context)),
//                 decoration: BoxDecoration(
//                     color: Colors.white, borderRadius: BorderRadius.circular(4)),
//                 child: Text('Week',
//                     style: TextStyle(fontSize: 10 * byWithScale(context))),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(
//                   vertical: 4 * byWithScale(context),
//                   horizontal: 6 * byWithScale(context)),
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(4)),
//               child: Text('2 Weeks',
//                   style: TextStyle(fontSize: 10 * byWithScale(context))),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(
//                   vertical: 4 * byWithScale(context),
//                   horizontal: 6 * byWithScale(context)),
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(4)),
//               child: Text('Month',
//                   style: TextStyle(fontSize: 10 * byWithScale(context))),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(
//                   vertical: 4 * byWithScale(context),
//                   horizontal: 6 * byWithScale(context)),
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(4)),
//               child: Text('Choose',
//                   style: TextStyle(fontSize: 10 * byWithScale(context))),
//             )
//           ],
//         ),
//         Text(
//           '...once on ${editableTask.timeStart.toString().substring(0, 10)}',
//           style: TextStyle(
//               fontSize: 10 * byWithScale(context), fontWeight: FontWeight.w400),
//         ),
//         Text(
//           '...and how long it will take',
//           style: TextStyle(
//               fontSize: 10 * byWithScale(context), fontWeight: FontWeight.w400),
//         ),
//         TimeSlider(
//           period: editableTask.period,
//           callback: (Duration newPeriod) {
//             setState(() {
//               editableTask = editableTask.copyWith(period: newPeriod);
//             });
//           },
//         ),
//         Text(
//           'What color should you task be?',
//           style: TextStyle(
//               fontSize: 12 * byWithScale(context), fontWeight: FontWeight.w600),
//         ),
//         ColorPickerRow(callback: (color) {
//           setState(() {
//             editableTask = editableTask.copyWith(color: color);
//           });
//         }),
//       ],
//     );
//   }
// }
