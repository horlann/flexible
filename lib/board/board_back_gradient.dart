import 'package:flutter/material.dart';

LinearGradient boardBackGradient = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  stops: [
    0.0,
    0.20,
    0.95,
  ],
  colors: [
    Color(0xFFFFFF).withOpacity(0.4),
    Color(0xA7A2A2).withOpacity(0.18),
    Color(0xDBD0D0).withOpacity(0.49)
  ],
);
