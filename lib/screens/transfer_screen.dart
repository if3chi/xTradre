import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xtradre/Service/xchange_service.dart';
import 'package:xtradre/constants/app_colors.dart';
import 'package:xtradre/enum/operator.dart';
import 'package:xtradre/model/xchange.dart';
import 'package:xtradre/widgets/add_transfers_modal.dart';
import 'package:xtradre/widgets/headers.dart';
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
  // Todo: refactor these variable names
  final amountToExchangeController = TextEditingController();
  final _resultController = TextEditingController();
  final exchangeRateController = TextEditingController();
  Operator operatorDropdownValue = Operator.multiply;
  late XchangeService _xchangeService;

  @override
  void initState() {
    super.initState();
    _xchangeService = XchangeService(widget.db);
  }

  void calculateResult() {
    final amountToExchange =
        double.tryParse(amountToExchangeController.text) ?? 0;
    final exchangeRate = double.tryParse(exchangeRateController.text) ?? 0;
    double result = XchangeService.calculateResult(
        amountToExchange, exchangeRate, operatorDropdownValue);

    _resultController.text = result.toStringAsFixed(2);

    setState(() {});
  }

  void submitExchangeRate(String currencyPair, double amountToExchange,
      double rate, DateTime timestamp, Operator operator, String reason) async {
    final result =
        XchangeService.calculateResult(amountToExchange, rate, operator);

    final exchangeRateData = Xchange(
        currencyPair: currencyPair,
        amount: amountToExchange,
        rAmount: result,
        operator: operator,
        rate: rate,
        timestamp: timestamp,
        reason: reason);

    await _xchangeService.insertXchangeRate(exchangeRateData);

    setState(() {
      amountToExchangeController.clear();
      _resultController.clear();
      exchangeRateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: AppColors.cPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TransfersSearchBar(),
            Container(
              margin: const EdgeInsets.only(top: 40, bottom: 5),
              child: const MainHeader(
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
      floatingActionButton: addBtn(context),
    );
  }

  FloatingActionButton addBtn(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isDismissible: false,
          isScrollControlled: true,
          builder: (context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: AddTransfersModal(
                onSubmit: submitExchangeRate,
                onAmountChanged: (amount) {
                  amountToExchangeController.text = amount;
                  calculateResult();
                },
                onRateChanged: (rate) {
                  exchangeRateController.text = rate;
                  calculateResult();
                },
                onOperatorChanged: (operator) => setState(() {
                  operatorDropdownValue = operator;
                  calculateResult();
                }),
                operator: operatorDropdownValue,
                result: double.tryParse(_resultController.text),
              ),
            ),
          ),
        );
      },
      elevation: 5.0,
      label: const Text('Add',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      icon: const Icon(Icons.add_chart, size: 24, weight: 6),
      foregroundColor: AppColors.cPrimary,
      backgroundColor: AppColors.cSecondary,
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const MainHeader(size: 22),
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
    return Expanded(child: Center(child: TextSm(text, size: size)));
  }
}
