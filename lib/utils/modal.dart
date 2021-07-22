import 'dart:ui';

import 'package:flutter/material.dart';

Future<dynamic> showModal(context, Widget widget) async {
  return await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (c) => Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                    color: Colors.transparent,
                    child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 0,
                            sigmaY: 0
                        ),
                        child: widget
                    )
                )
              ]
          )
      )
  );
}