import 'package:flutter/material.dart';
import 'package:xtradre/constants/colors.dart';
import 'package:xtradre/widgets/svg_icon.dart';

class AppBarIcon extends StatelessWidget {
  final String path;
  final Function tap;
  final double? iWidth;
  final double? iHeight;
  final double? cWidth;

  const AppBarIcon({
    super.key,
    required this.path,
    required this.tap,
    this.iWidth = 25,
    this.iHeight = 25,
    this.cWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => tap(),
      child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          width: cWidth,
          decoration: BoxDecoration(
            color: cLightAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgIcon(path, iWidth: iWidth, iHeight: iHeight)),
    );
  }
}
