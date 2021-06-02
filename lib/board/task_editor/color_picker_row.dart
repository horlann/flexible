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
                width: 6,
              ),
              Text(name,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
              SizedBox(
                width: 4,
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(10)),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            colorPart(color: Colors.lime, name: 'Lime'),
            colorPart(color: Colors.redAccent, name: 'RedC'),
            colorPart(color: Colors.indigo, name: 'Indigo'),
            colorPart(color: Colors.cyan, name: 'Cyan'),
            colorPart(color: Colors.amber, name: 'Amber'),
            colorPart(color: Colors.deepPurple, name: 'DeepPurple'),
          ],
        ),
      ),
    );
  }
}
