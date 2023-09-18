import 'package:xtradre/enum/operator.dart';

class Xchange {
  static const tableName = "xchanges";

  final int? id;
  final String currencyPair;
  final double rate;
  final double amount;
  final double rAmount;
  final Operator operator;
  final String? reason;
  final DateTime timestamp;

  Xchange({
    this.id,
    this.reason,
    required this.currencyPair,
    required this.amount,
    required this.rAmount,
    required this.rate,
    required this.operator,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currencyPair': currencyPair,
      'amount': amount,
      'rAmount': rAmount,
      'rate': rate,
      'operator': operator.index,
      'reason': reason,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Xchange.fromMap(Map<String, dynamic> map) {
    return Xchange(
      id: map['id'],
      currencyPair: map['currencyPair'],
      amount: map['amount'],
      rAmount: map['rAmount'],
      rate: map['rate'],
      operator: Operator.values[map['operator']],
      reason: map['reason'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
