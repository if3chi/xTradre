import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtradre/constants/colors.dart';

class TransfersSearchBar extends StatelessWidget {
  const TransfersSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: cSecondary.withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: cSecondary,
          hintText: 'X Tranfers',
          hintStyle:  const TextStyle(color: cAccent, fontSize: 14),
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          prefixIcon: Padding(
              padding: const EdgeInsets.all(15),
              child: SvgPicture.asset(
                'assets/svg/search.svg',
                color: cAction,
                width: 15,
                height: 15,
              )),
          suffixIcon: SizedBox(
            width: 100.0,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const VerticalDivider(
                    thickness: 0.4,
                    color: cAction,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 15, left: 5, right: 15),
                      child: SvgPicture.asset(
                        'assets/svg/sliders.svg',
                        color: cAction,
                        width: 15,
                        height: 15,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
