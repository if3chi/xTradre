import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xtradre/Service/xchange_service.dart';
import 'package:xtradre/constants/colors.dart';
import 'package:xtradre/model/xchange.dart';
import 'package:xtradre/widgets/head_title.dart';
import 'package:xtradre/widgets/app_bar_icon.dart';
import 'package:xtradre/widgets/tranfer_card.dart';
import 'package:xtradre/widgets/transfers_search_bar.dart';

class TransferScreen extends StatefulWidget {
  final Database db;

  const TransferScreen({super.key, required this.db});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  late XchangeService _xchangeService;

  @override
  void initState() {
    super.initState();
    _xchangeService = XchangeService(widget.db);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TransfersSearchBar(),
            Container(
              margin: const EdgeInsets.only(top: 40, bottom: 5),
              child: const HeadTitle(
                  title: "All Transfers",
                  size: 16,
                  fontWeight: FontWeight.w800),
            ),
            FutureBuilder<List<Xchange>>(
              future: _xchangeService.getXchangeRates(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return ErrText('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const ErrText('No exchange rate data available.');
                } else {
                  final exchangeRates = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: exchangeRates.length,
                      itemBuilder: (context, index) {
                        return TranferCard(transfer: exchangeRates[index]);
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
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

class ErrText extends StatelessWidget {
  final String text;
  final double size;

  const ErrText(this.text, {super.key, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(child: TextSm(text, size: size)),
    );
  }
}
