import 'package:flutter/material.dart';

class ColorPickerRow extends StatelessWidget {
  const ColorPickerRow({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final Function(Color color) callback;

  @override
  Widget build(BuildContext context) {
    Widget colorPart({required Color color, required String name}) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            callback(color);
          },
          child: Row(
            children: [
              SizedBox(
                width: 3,
              ),
              Text(name,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
              SizedBox(
                width: 2,
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    //border: Border.all(color: Colors.black),
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
          colorPart(color: Colors.lime, name: ''),
          colorPart(color: Colors.redAccent, name: ''),
          colorPart(color: Colors.indigo, name: ''),
          colorPart(color: Colors.cyan, name: ''),
          colorPart(color: Colors.amber, name: ''),
          colorPart(color: Colors.deepPurple, name: ''),
        ],
      ),
    );
  }
}
