import 'package:flutter/material.dart';
import 'package:xtradre/constants/app_colors.dart';

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
        color: AppColors.cAction,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}

class SubHeader extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final FontWeight fontWeight;

  const SubHeader(
      {super.key,
      this.text = 'Xchanges',
      this.size = 14.0,
      this.fontWeight = FontWeight.bold,
      this.color = AppColors.cAction});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: size, fontWeight: fontWeight),
    );
  }
}
