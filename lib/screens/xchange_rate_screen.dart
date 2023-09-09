import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xtradre/core/utils.dart';
import 'package:xtradre/enum/operator.dart';
import 'package:xtradre/model/xchange.dart';
import 'package:xtradre/Service/xchange_service.dart';
import 'package:xtradre/screens/xchange_form.dart';

class XchangeRateScreen extends StatefulWidget {
  final Database db;
  const XchangeRateScreen(this.db, {super.key});

  @override
  createState() => _XchangeRateScreenState();
}

class _XchangeRateScreenState extends State<XchangeRateScreen> {
  // final _formKey = GlobalKey<FormState>();
  final _currencyPairController = TextEditingController();
  final _amountToExchangeController = TextEditingController();
  final _resultController = TextEditingController();
  final _exchangeRateController = TextEditingController();
  // TODO: add sender name, reason.
  Operator _operatorDropdownValue =
      Operator.multiply; // Initialize it with a default value
  late XchangeService _xchangeService;

  @override
  void initState() {
    super.initState();
    _xchangeService = XchangeService(widget.db);
  }

  void _calculateResult() {
    final amountToExchange =
        double.tryParse(_amountToExchangeController.text) ?? 0;
    final exchangeRate = double.tryParse(_exchangeRateController.text) ?? 0;
    double result = XchangeService.calculateResult(
        amountToExchange, exchangeRate, _operatorDropdownValue);
    _resultController.text = result.toStringAsFixed(2);
  }

  void _submitExchangeRate(String currencyPair, double amountToExchange,
      double rate, DateTime timestamp, Operator operator) async {
    final result =
        XchangeService.calculateResult(amountToExchange, rate, operator);

    final exchangeRateData = Xchange(
      currencyPair: currencyPair,
      amount: amountToExchange,
      rAmount: result,
      operator: operator,
      rate: rate,
      timestamp: timestamp,
    );

    await _xchangeService.insertXchangeRate(exchangeRateData);

    setState(() {
      _currencyPairController.clear();
      _amountToExchangeController.clear();
      _resultController.clear();
      _exchangeRateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exchange Rate Recorder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return XchangeRateFormDialog(
                      onSubmit: _submitExchangeRate,
                      onAmountChanged: (amount) {
                        _amountToExchangeController.text = amount;
                        _calculateResult();
                      },
                      onRateChanged: (rate) {
                        _exchangeRateController.text = rate;
                        _calculateResult();
                      },
                      onOperatorChanged: (operator) {
                        setState(() {
                          _operatorDropdownValue = operator;
                          _calculateResult();
                        });
                      },
                      operator: _operatorDropdownValue,
                    );
                  },
                );
              },
              child: const Text('Add Exchange Rate'),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Xchange>>(
              future: _xchangeService.getXchangeRates(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No exchange rate data available.');
                } else {
                  final exchangeRates = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: exchangeRates.length,
                      itemBuilder: (context, index) {
                        final rate = exchangeRates[index];
                        return ListTile(
                          isThreeLine: true,
                          leading: Text(Utils.displayDate(rate.timestamp)),
                          title: Text(rate.currencyPair),
                          subtitle: Text(
                              'Amount: ${rate.amount.toStringAsFixed(2)} / Result: ${rate.rAmount.toStringAsFixed(2)} @ ${rate.rate.toStringAsFixed(4)}'),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
