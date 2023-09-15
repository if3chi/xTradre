import 'package:flutter/material.dart';
import 'package:xtradre/constants/colors.dart';
import 'package:xtradre/constants/space.dart';
import 'package:xtradre/core/utils.dart';
import 'package:xtradre/enum/operator.dart';
import 'package:xtradre/widgets/headers.dart';

class AddTransfersModal extends StatefulWidget {
  final void Function(String, double, double, DateTime, Operator) onSubmit;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onRateChanged;
  final ValueChanged<Operator> onOperatorChanged;
  final Operator operator;

  const AddTransfersModal({
    super.key,
    required this.onSubmit,
    required this.onAmountChanged,
    required this.onRateChanged,
    required this.onOperatorChanged,
    required this.operator,
  });

  @override
  State<AddTransfersModal> createState() => _AddTransfersModalState();
}

class _AddTransfersModalState extends State<AddTransfersModal> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Center(child: MainHeader(title: "Add Transfer", size: 20)),
                Divider(thickness: 3),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 14, bottom: 6, left: 12, right: 12),
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
                spaceYmd,
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
                spaceYmd,
                TextFormField(
                    controller: _exchangeRateController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration:
                        const InputDecoration(labelText: 'Exchange Rate'),
                    onChanged: widget.onRateChanged,
                    validator: (value) => value!.isEmpty
                        ? 'Please enter an exchange rate'
                        : (double.tryParse(value) == null
                            ? 'Invalid exchange rate'
                            : null)),
                spaceYmd,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Operator:'),
                    spaceXsm,
                    DropdownButton<Operator>(
                      value: _operatorDropdownValue,
                      items: Operator.values.map((Operator value) {
                        return DropdownMenuItem<Operator>(
                          value: value,
                          child: Text(value == Operator.multiply
                              ? 'Multiply'
                              : 'Divide'),
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
                  ],
                ),
                spaceYmd,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Date (Optional):'),
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
                      child: Text(Utils.displayDate(_selectedDate),
                          style: const TextStyle(color: cAction)),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Btn(text: 'Save', fn: _submitForm),
                spaceYxs,
                const Btn(text: 'Cancel', bgColor: cPrimary),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Btn extends StatelessWidget {
  final String text;
  final Color fgColor;
  final Color bgColor;
  final VoidCallback? fn;

  const Btn({
    super.key,
    required this.text,
    this.fn,
    this.fgColor = cAction,
    this.bgColor = cAccent,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: fn ?? () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            backgroundColor: bgColor),
        child: SubHeader(
            title: text, fontWeight: FontWeight.w600, color: fgColor));
  }
}
