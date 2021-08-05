import 'package:flutter/material.dart';

class ColorPickerRow extends StatefulWidget {
  final int? activeButton;

  const ColorPickerRow({
    Key? key,
    this.activeButton,
    required this.callback,
  }) : super(key: key);

  final Function(Color color, int pos) callback;

  @override
  _ColorPickerRowState createState() => _ColorPickerRowState();
}

class _ColorPickerRowState extends State<ColorPickerRow> {
  List<bool> isActiveArray = [false, false, true, false, false, false];

  @override
  Widget build(BuildContext context) {
    Widget colorPart(
        {required Color color,
        required String name,
        bool? isActive,
        int? pos}) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            widget.callback(color, pos!);
            isActiveArray = [false, false, true, false, false, false];
            isActiveArray[pos] = true;
            isActiveArray.forEach((element) => print(element));
          },
          child: Row(
            children: [
              SizedBox(
                width: 3,
              ),
              SizedBox(
                width: 2,
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    border: isActive!
                        ? Border.all(color: Colors.black, width: 2)
                        : null,
                    color: color,
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(
                width: 6,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          colorPart(
              color: Colors.lime, name: '', isActive: isActiveArray[0], pos: 0),
          colorPart(
              color: Colors.redAccent,
              name: '',
              isActive: isActiveArray[1],
              pos: 1),
          colorPart(
              color: Colors.indigo,
              name: '',
              isActive: isActiveArray[2],
              pos: 2),
          colorPart(
              color: Colors.cyan, name: '', isActive: isActiveArray[3], pos: 3),
          colorPart(
              color: Colors.amber,
              name: '',
              isActive: isActiveArray[4],
              pos: 4),
          colorPart(
              color: Colors.deepPurple,
              name: '',
              isActive: isActiveArray[5],
              pos: 5),
        ],
      ),
    );
  }
}
