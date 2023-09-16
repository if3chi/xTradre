import 'package:flutter/material.dart';
import 'package:xtradre/constants/app_colors.dart';
import 'package:xtradre/widgets/svg_icon.dart';

class TransfersSearchBar extends StatelessWidget {
  const TransfersSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: AppColors.cSecondary.withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.cSecondary,
          hintText: 'X Tranfers',
          hintStyle: TextStyle(color: AppColors.cLightAccent, fontSize: 14),
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          prefixIcon: const Padding(
              padding: EdgeInsets.all(15),
              child: SvgIcon('assets/svg/search.svg')),
          suffixIcon: const SizedBox(
            width: 100.0,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  VerticalDivider(
                    thickness: 0.4,
                    color: AppColors.cAction,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 5, right: 15),
                      child: SvgIcon('assets/svg/sliders.svg'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
