import 'package:flutter/material.dart';
import 'package:xtradre/constants/colors.dart';
import 'package:xtradre/constants/space.dart';
import 'package:xtradre/core/utils.dart';
import 'package:xtradre/model/xchange.dart';
import 'package:xtradre/widgets/svg_icon.dart';

class TranferCard extends StatelessWidget {
  final Xchange transfer;

  const TranferCard({super.key, required this.transfer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getDate(Utils.displayDate(transfer.timestamp), isSameDay: true),
          spaceYxs,
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: cSecondary.withOpacity(0.11),
                  blurRadius: 3,
                  spreadRadius: 5)
            ]),
            child: ListTile(
              onTap: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              tileColor: cLightAccent,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SvgIcon('assets/svg/money-swap.svg',
                              iWidth: 25, iHeight: 25),
                          spaceXxs,
                          TextSm(transfer.currencyPair,
                              size: 16, fontWeight: FontWeight.w500),
                        ],
                      ),
                      spaceYxs,
                      TextSm(
                        'Rate: ${formatMoney(transfer.rate, fraction: 4)}',
                        fontWeight: FontWeight.w100,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextSm(formatMoney(transfer.amount),
                          fontWeight: FontWeight.w600),
                      spaceYxs,
                      TextSm(formatMoney(transfer.rAmount),
                          fontWeight: FontWeight.w600)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatMoney(double amount, {int fraction = 2}) {
    return amount.toStringAsFixed(fraction);
  }

  Widget getDate(String text, {bool isSameDay = false}) {
    return isSameDay
        ? Padding(
            padding: const EdgeInsets.only(left: 14.0, top: 8.0),
            child: TextSm(
              text,
              size: 9,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
              color: cAction.withOpacity(0.8),
            ),
          )
        : const SizedBox();
  }
}

class TextSm extends StatelessWidget {
  final String text;
  final double size;
  final FontStyle fontStyle;
  final Color color;
  final FontWeight fontWeight;

  const TextSm(
    this.text, {
    super.key,
    this.size = 12,
    this.fontStyle = FontStyle.normal,
    this.color = cAction,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontStyle: fontStyle,
          fontSize: size,
          color: color,
          fontWeight: fontWeight),
    );
  }
}
