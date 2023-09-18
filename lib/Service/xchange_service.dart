import 'package:sqflite/sqflite.dart';
import 'package:xtradre/enum/operator.dart';
import 'package:xtradre/model/xchange.dart';

class XchangeService {
  late Database database;
  final String _table = Xchange.tableName;

  XchangeService(this.database);

  Future<void> insertXchangeRate(Xchange xchangeRateData) async {
    await database.insert(
      _table,
      xchangeRateData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Xchange>> getXchangeRates() async {
    final List<Map<String, dynamic>> maps = await database.query(_table);

    return List.generate(maps.length, (i) {
      return Xchange.fromMap(maps[i]);
    });
  }

  static double calculateResult(
      double amountToExchange, double exchangeRate, Operator operator) {
    double result;

    if (operator == Operator.multiply) {
      result = amountToExchange * exchangeRate;
    } else {
      if (exchangeRate == 0) {
        result = 0;
      } else {
        result = amountToExchange / exchangeRate;
      }
    }

    return result;
  }
}
