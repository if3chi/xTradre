import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xtradre/Enum/operator.dart';
import 'package:xtradre/model/xchange.dart';
import 'package:xtradre/Service/xchange_service.dart';

class XchangeRateScreen extends StatefulWidget {
  final Database db;
  const XchangeRateScreen(this.db, {super.key});

  @override
  createState() => _XchangeRateScreenState();
}

class _XchangeRateScreenState extends State<XchangeRateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currencyPairController = TextEditingController();
  final _amountToExchangeController = TextEditingController();
  final _resultController = TextEditingController();
  final _exchangeRateController = TextEditingController();

  late XchangeService _xchangeService;
  Operator _operatorDropdownValue = Operator.multiply;

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

  void _submitExchangeRate() async {
    if (_formKey.currentState!.validate()) {
      final currencyPair = _currencyPairController.text;
      final amount = double.parse(_amountToExchangeController.text);
      final rAmount = double.parse(_resultController.text);
      final exchangeRate = double.parse(_exchangeRateController.text);

      final exchangeRateData = Xchange(
        currencyPair: currencyPair,
        amount: amount,
        rAmount: rAmount,
        rate: exchangeRate,
        operator: _operatorDropdownValue,
        timestamp: DateTime.now(),
      );

      await _xchangeService.insertXchangeRate(exchangeRateData);
      setState(() {});

      _currencyPairController.clear();
      _amountToExchangeController.clear();
      _resultController.clear();
      _exchangeRateController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RateBook')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _currencyPairController,
                decoration: const InputDecoration(
                    labelText: 'Currency Pair (e.g., USD to EUR)'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a currency pair' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountToExchangeController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration:
                    const InputDecoration(labelText: 'Amount to Exchange'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an amount' : null,
                onChanged: (_) => _calculateResult(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _exchangeRateController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Exchange Rate'),
                validator: (value) => value!.isEmpty
                    ? 'Please enter an exchange rate'
                    : (double.tryParse(value) == null
                        ? 'Invalid exchange rate'
                        : null),
                onChanged: (_) => _calculateResult(),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  const Text('Operator: '),
                  DropdownButton<Operator>(
                    value: _operatorDropdownValue,
                    onChanged: (Operator? newValue) {
                      setState(() {
                        _operatorDropdownValue = newValue!;
                        _calculateResult();
                      });
                    },
                    items: Operator.values
                        .map<DropdownMenuItem<Operator>>((Operator value) {
                      return DropdownMenuItem<Operator>(
                        value: value,
                        child: Text(value == Operator.multiply ? '*' : '/'),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _resultController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Result'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitExchangeRate,
                child: const Text('Submit'),
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
                        reverse: true,
                        itemCount: exchangeRates.length,
                        itemBuilder: (context, index) {
                          final rate = exchangeRates[index];
                          return ListTile(
                            isThreeLine: true,
                            leading: Text(rate.timestamp.toLocal().toString()),
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
      ),
    );
  }
}
