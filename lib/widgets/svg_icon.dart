import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtradre/constants/app_colors.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.path, {
    super.key,
    this.iWidth = 15.0,
    this.iHeight = 15.0,
    this.color,
  });

  final String path;
  final double? iWidth;
  final double? iHeight;
  final ColorFilter? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: iWidth,
      height: iHeight,
      colorFilter:
          color ?? const ColorFilter.mode(AppColors.cAction, BlendMode.srcIn),
    );
  }
}
