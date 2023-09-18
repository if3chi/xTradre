import 'package:flutter/material.dart';
import 'package:xtradre/constants/app_colors.dart';
import 'package:xtradre/constants/space.dart';
import 'package:xtradre/core/utils.dart';
import 'package:xtradre/enum/operator.dart';
import 'package:xtradre/widgets/app_text_field.dart';
import 'package:xtradre/widgets/headers.dart';
import 'package:xtradre/widgets/svg_icon.dart';

class AddTransfersModal extends StatefulWidget {
  final void Function(String, double, double, DateTime, Operator, String)
      onSubmit;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onRateChanged;
  final ValueChanged<Operator> onOperatorChanged;
  final Operator operator;
  final double? result;

  const AddTransfersModal({
    super.key,
    this.result,
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
  final _formKey = GlobalKey<FormState>();
  final _currencyPairController = TextEditingController();
  final _amountToExchangeController = TextEditingController();
  final _xRateController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Operator _operatorDropdownValue = Operator.multiply;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final currencyPair = _currencyPairController.text;
      final reason = _reasonController.text;
      final amountToExchange = double.parse(_amountToExchangeController.text);
      final exchangeRate = double.parse(_xRateController.text);

      widget.onSubmit(currencyPair.toUpperCase(), amountToExchange,
          exchangeRate, _selectedDate, _operatorDropdownValue, reason);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: SubHeader(
              text: 'Transfer Added Successfully.',
              color: AppColors.cPrimary,
            ),
          ),
          backgroundColor: Colors.greenAccent,
          elevation: 10,
        ),
      );
    }
  }

  @override
  void dispose() {
    _currencyPairController.dispose();
    _amountToExchangeController.dispose();
    _xRateController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          formHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // TODO: fix input resizing on err
                // TODO: get currency pair api n impl. a dropdown
                inputField(
                  controller: _currencyPairController,
                  text: "Currency pair",
                  hintText: "e.g., USD/GHS",
                  keyType: TextInputType.text,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the currency pair' : null,
                ),
                spaceYxs,
                inputField(
                  controller: _amountToExchangeController,
                  text: "Amount",
                  hintText: '5000',
                  onChanged: widget.onAmountChanged,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an amount' : null,
                ),
                spaceYxs,
                inputField(
                    controller: _xRateController,
                    text: "Rate",
                    hintText: '0.0123',
                    onChanged: widget.onRateChanged,
                    validator: (value) => value!.isEmpty
                        ? 'Please enter an exchange rate'
                        : (double.tryParse(value) == null
                            ? 'Invalid exchange rate'
                            : null)),
                spaceYxs,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    dropDown(),
                    spaceXsm,
                    datePicker(context),
                  ],
                ),
                // spaceYxs,
                widget.result != null
                    ? SubHeader(
                        text: 'Resulting Amount: ${widget.result}',
                        size: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.cAction.withOpacity(0.9),
                      )
                    : const SizedBox(),
                spaceYxs,
                inputField(
                    controller: _reasonController,
                    text: "Reason",
                    hintText: "Transfer to myself...",
                    textArea: true,
                    keyType: TextInputType.multiline,
                    maxLines: 3),
              ],
            ),
          ),
          spaceYmd,
          formFooter()
        ],
      ),
    );
  }

  Row dropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SubHeader(text: 'Use:', fontWeight: FontWeight.w500),
        spaceXsm,
        DropdownButton<Operator>(
          borderRadius: BorderRadius.circular(8),
          iconSize: 32,
          iconEnabledColor: AppColors.cSecondary,
          style: const TextStyle(
              fontSize: 16,
              color: AppColors.cSecondary,
              fontWeight: FontWeight.w600),
          value: _operatorDropdownValue,
          items: Operator.values.map((Operator value) {
            return DropdownMenuItem<Operator>(
              value: value,
              child: Text(value == Operator.multiply ? 'Multiply' : 'Divide'),
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
        spaceXsm,
      ],
    );
  }

  ElevatedButton datePicker(BuildContext context) {
    return ElevatedButton(
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
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          backgroundColor: AppColors.cAccent),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SvgIcon(
            'assets/svg/calendar.svg',
            iWidth: 20,
            iHeight: 20,
            color: ColorFilter.mode(AppColors.cPrimary, BlendMode.srcIn),
          ),
          spaceXsm,
          SubHeader(
            text: Utils.displayDate(_selectedDate),
            size: 14,
            color: AppColors.cPrimary,
          ),
        ],
      ),
    );
  }

  Container formFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Btn(text: 'Save', fn: _submitForm, fgColor: AppColors.cPrimary),
          spaceYxs,
          const Btn(text: 'Cancel', bgColor: AppColors.cPrimary),
        ],
      ),
    );
  }

  Padding formHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Center(child: MainHeader(title: "Add Transfer", size: 20)),
          Divider(thickness: 3),
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
    this.fgColor = AppColors.cAction,
    this.bgColor = AppColors.cAccent,
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
        child:
            SubHeader(text: text, fontWeight: FontWeight.w800, color: fgColor));
  }
}
