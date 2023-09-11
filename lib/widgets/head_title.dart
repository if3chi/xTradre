import 'package:flutter/material.dart';
import 'package:xtradre/constants/colors.dart';

class HeadTitle extends StatelessWidget {
  final double size;
  final String title;
  final FontWeight fontWeight;

  const HeadTitle(
      {super.key,
      this.title = 'Xchanges',
      this.size = 18.0,
      this.fontWeight = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: cAction,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
