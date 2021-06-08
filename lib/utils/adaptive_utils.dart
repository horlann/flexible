import 'package:flutter/material.dart';

double pRatio(context) => MediaQuery.of(context).devicePixelRatio;

double hpRatio(context) => MediaQuery.of(context).devicePixelRatio / 2;

double byWithScale(BuildContext context) {
  double deviceWidth = MediaQuery.of(context).size.width;
  if (deviceWidth > 450) return 1.5;
  if (deviceWidth > 400) return 1.3;
  if (deviceWidth > 350) return 1.2;
  if (deviceWidth > 320) return 1.05;
  return 1;
}
