import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader({
    super.key,
    this.loaderColor = Colors.purple,
    this.radius = 20,
    this.strokeWidth = 2,
  });
  final Color loaderColor;
  final double radius;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActivityIndicator(
            color: loaderColor,
            radius: radius,
          )
        : SizedBox(
            height: radius,
            width: radius,
            child: CircularProgressIndicator(
              color: loaderColor,
              strokeWidth: strokeWidth,
            ),
          );
  }
}
