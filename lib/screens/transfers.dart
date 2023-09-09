import 'package:flutter/material.dart';
import 'package:xtradre/constants/colors.dart';
import 'package:xtradre/widgets/head_title.dart';
import 'package:xtradre/widgets/app_bar_icon.dart';
import 'package:xtradre/screens/transfers_search_bar.dart';

class Transfers extends StatelessWidget {
  const Transfers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: ListView(children: const [
        TransfersSearchBar(),
        Column(),
        SizedBox(height: 40)
      ]),
      floatingActionButton: addBtn(),
    );
  }

  FloatingActionButton addBtn() {
    return FloatingActionButton.extended(
      onPressed: () {},
      elevation: 5.0,
      label: const Text('Add',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      icon: const Icon(Icons.add_chart, size: 24, weight: 6),
      foregroundColor: cPrimary,
      backgroundColor: cSecondary,
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const HeadTitle(size: 22),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: AppBarIcon(path: 'assets/svg/left.svg', tap: () {}),
      actions: [
        AppBarIcon(path: 'assets/svg/more.svg', tap: () {}, cWidth: 37)
      ],
    );
  }
}
