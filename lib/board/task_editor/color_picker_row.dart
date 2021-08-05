import 'package:flutter/material.dart';

class ColorPickerRow extends StatefulWidget {
  const ColorPickerRow({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final Function(Color color) callback;

  @override
  _ColorPickerRowState createState() => _ColorPickerRowState();
}

class _ColorPickerRowState extends State<ColorPickerRow> {
  Color selectedColor = Colors.cyan;

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
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              selectedColor = color;
            });
            widget.callback(color);
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
              color: Colors.lime,
              name: '',
              isActive: Colors.lime == selectedColor),
          colorPart(
              color: Colors.redAccent,
              name: '',
              isActive: Colors.redAccent == selectedColor,
              pos: 1),
          colorPart(
              color: Colors.indigo,
              name: '',
              isActive: Colors.indigo == selectedColor,
              pos: 2),
          colorPart(
              color: Colors.cyan,
              name: '',
              isActive: Colors.cyan == selectedColor),
          colorPart(
              color: Colors.amber,
              name: '',
              isActive: Colors.amber == selectedColor,
              pos: 4),
          colorPart(
              color: Colors.deepPurple,
              name: '',
              isActive: Colors.deepPurple == selectedColor,
              pos: 5),
        ],
      ),
    );
  }
}
