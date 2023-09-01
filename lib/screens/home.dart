import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:xtradre/Enum/operator.dart';
import 'package:xtradre/model/xchange.dart';

class XchangeRateScreen extends StatefulWidget {
  const XchangeRateScreen({super.key});

  @override
  createState() => _XchangeRateScreenState();
}

class _XchangeRateScreenState extends State<XchangeRateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currencyPairController = TextEditingController();
  final _amountToExchangeController = TextEditingController();
  final _resultController = TextEditingController();
  final _exchangeRateController = TextEditingController();

  var ratesTable = 'xchanges';
  Operator _operatorDropdownValue = Operator.multiply;

  late Database _database;

  @override
  void initState() {
    super.initState();
    _initDatabase().then((_) {
      _getXchangeRates();
    });
  }

  Future<void> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'xtradre.db');

    bool exists = await databaseExists(path);

    if (!exists) {
      try {
        await openDatabase(
          path,
          version: 1,
          onCreate: (Database db, int version) {
            db.execute('''
            CREATE TABLE $ratesTable(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              currencyPair TEXT,
              amount REAL,
              rAmount REAL,
              operator INTEGER,
              rate REAL,
              timestamp TEXT
            )
          ''');
          },
        );
      } catch (e) {
        print("Error creating the database: $e");
      }
    }

    _database = await openDatabase(path);
  }

  void _calculateResult() {
    double result;
    final amountToExchange =
        double.tryParse(_amountToExchangeController.text) ?? 0;
    final exchangeRate = double.tryParse(_exchangeRateController.text) ?? 0;

    if (_operatorDropdownValue == Operator.multiply) {
      result = amountToExchange * exchangeRate;
    } else {
      if (exchangeRate == 0) {
        result = 0;
      } else {
        result = amountToExchange / exchangeRate;
      }
    }

    _resultController.text = result.toStringAsFixed(2);
  }

  void _submitExchangeRate() async {
    if (_formKey.currentState!.validate()) {
      final currencyPair = _currencyPairController.text;
      final amount = double.parse(_amountToExchangeController.text);
      final rAmount = double.parse(_resultController.text);
      final exchangeRate = double.parse(_exchangeRateController.text);

      final exchangeRateData = XchangeRate(
        id: 0,
        currencyPair: currencyPair,
        amount: amount,
        rAmount: rAmount,
        rate: exchangeRate,
        operator: _operatorDropdownValue,
        timestamp: DateTime.now(),
      );

      await _insertExchangeRate(exchangeRateData);

      _currencyPairController.clear();
      _amountToExchangeController.clear();
      _resultController.clear();
      _exchangeRateController.clear();
    }
  }

  Future<void> _insertExchangeRate(XchangeRate xchangeRateData) async {
    await _database.insert(
      ratesTable,
      xchangeRateData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    setState(() {});
  }

  Future<List<XchangeRate>> _getXchangeRates() async {
    final List<Map<String, dynamic>> maps = await _database.query(ratesTable);
    return List.generate(maps.length, (i) {
      return XchangeRate.fromMap(maps[i]);
    });
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
              FutureBuilder<List<XchangeRate>>(
                future: _getXchangeRates(),
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
