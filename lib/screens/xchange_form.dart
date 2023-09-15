import 'package:flutter/material.dart';
import 'package:xtradre/core/utils.dart';
import 'package:xtradre/enum/operator.dart';

class XchangeRateFormDialog extends StatefulWidget {
  final void Function(String, double, double, DateTime, Operator) onSubmit;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onRateChanged;
  final ValueChanged<Operator> onOperatorChanged;
  final Operator operator;

  const XchangeRateFormDialog({
    super.key,
    required this.onSubmit,
    required this.onAmountChanged,
    required this.onRateChanged,
    required this.onOperatorChanged,
    required this.operator,
  });

  @override
  createState() => _XchangeRateFormDialogState();
}

class _XchangeRateFormDialogState extends State<XchangeRateFormDialog> {
  final _currencyPairController = TextEditingController();
  final _amountToExchangeController = TextEditingController();
  final _exchangeRateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Operator _operatorDropdownValue = Operator.multiply;

  void _submitForm() {
    final currencyPair = _currencyPairController.text;
    final amountToExchange = double.parse(_amountToExchangeController.text);
    final exchangeRate = double.parse(_exchangeRateController.text);

    widget.onSubmit(currencyPair, amountToExchange, exchangeRate, _selectedDate,
        _operatorDropdownValue);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Exchange Rate'),
      content: SingleChildScrollView(
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
              onChanged: widget.onAmountChanged,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter an amount' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _exchangeRateController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Exchange Rate'),
              onChanged: widget.onRateChanged,
              validator: (value) => value!.isEmpty
                  ? 'Please enter an exchange rate'
                  : (double.tryParse(value) == null
                      ? 'Invalid exchange rate'
                      : null),
            ),
            const SizedBox(height: 16),
            const Text('Operator:'),
            const SizedBox(height: 8),
            DropdownButton<Operator>(
              value: _operatorDropdownValue,
              items: Operator.values.map((Operator value) {
                return DropdownMenuItem<Operator>(
                  value: value,
                  child:
                      Text(value == Operator.multiply ? 'Multiply' : 'Divide'),
                );
              }).toList(),
              onChanged: (Operator? newValue) {
                if (newValue != null) {
                  setState(() {
                    _operatorDropdownValue = newValue;
                    widget.onOperatorChanged(newValue);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            const Text('Date (Optional):'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                );

                if (selectedDate != null) {
                  setState(() {
                    _selectedDate = selectedDate;
                  });
                }
              },
              child: Text(Utils.displayDate(_selectedDate)),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
