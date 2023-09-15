import 'package:flutter/material.dart';
import 'package:xtradre/constants/colors.dart';

class MainHeader extends StatelessWidget {
  final double size;
  final String title;
  final FontWeight fontWeight;

  const MainHeader(
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

class SubHeader extends StatelessWidget {
  final double size;
  final String title;
  final Color color;
  final FontWeight fontWeight;

  const SubHeader(
      {super.key,
      this.title = 'Xchanges',
      this.size = 14.0,
      this.fontWeight = FontWeight.bold,
      this.color = cAction});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: color, fontSize: size, fontWeight: fontWeight),
    );
  }
}
