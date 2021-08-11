import 'package:animated_check/animated_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class DoneCheckbox extends StatefulWidget {
  const DoneCheckbox({
    Key? key,
    required this.onClick,
    required this.checked,
  }) : super(key: key);

  final Function onClick;
  final bool checked;

  @override
  _DoneCheckboxState createState() => _DoneCheckboxState();
}

class _DoneCheckboxState extends State<DoneCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _animState = false;
  bool _canVibrate = true;

  @override
  void initState() {
    super.initState();
    init();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));

    _animation = new Tween<double>(begin: 0, end: 1).animate(
        new CurvedAnimation(parent: _animationController, curve: Curves.ease));
  }

  init() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
      _canVibrate
          ? print("This device can vibrate")
          : print("This device cannot vibrate");
    });
  }

  Future<void> vibro() async {
    !_canVibrate
        ? null
        : () {
            Vibrate.feedback(FeedbackType.light);
          };
  }

  @override
  Widget build(BuildContext context) {
    print(widget.checked.toString() + "     ddd");
    _animState = widget.checked;
    return GestureDetector(
      onTap: () =>
      {
        widget.onClick(),
        _animState
            ? {_animationController.reset()}
            : {_animationController.forward(), vibro()},
        _animState = !_animState,
        print(_animState)
      },
      child: Container(
          margin: EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color(0xff6E6B6B).withOpacity(0.75),
                  blurRadius: 20,
                  offset: Offset(0, 10))
            ],
          ),
          child: AnimatedCrossFade(
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeIn,
              firstChild: Center(
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red, width: 2.5)),
                  child: AnimatedCheck(
                    progress: _animation,
                    size: 200,
                    color: Color(0xffE24F4F),
                  ),
                ),
              ),
              secondChild: Center(
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red, width: 2.5)),
                ),
              ),
              crossFadeState: widget.checked
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 100))),
    );
  }
}
