import 'package:flutter/material.dart';

SnackBar messageSnakbar({required String text}) {
  return SnackBar(
      backgroundColor: Color(0xffE24F4F),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.announcement_outlined,
                color: Colors.white,
                size: 14,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(color: Colors.white),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ));
}
