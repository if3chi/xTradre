import 'package:xtradre/Enum/operator.dart';

class XchangeRate {
  final int? id;
  final String currencyPair;
  final double rate;
  final double amount;
  final double rAmount;
  final Operator operator;
  final DateTime timestamp;

  XchangeRate(
      {this.id,
      required this.currencyPair,
      required this.amount,
      required this.rAmount,
      required this.rate,
      required this.operator,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currencyPair': currencyPair,
      'amount': amount,
      'rAmount': rAmount,
      'rate': rate,
      'operator': operator.index,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory XchangeRate.fromMap(Map<String, dynamic> map) {
    return XchangeRate(
      id: map['id'],
      currencyPair: map['currencyPair'],
      amount: map['amount'],
      rAmount: map['rAmount'],
      rate: map['rate'],
      operator: Operator.values[map['operator']],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
