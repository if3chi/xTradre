import 'package:sqflite/sqflite.dart';
import 'package:xtradre/Enum/operator.dart';
import 'package:xtradre/Service/db_service.dart';
import 'package:xtradre/model/xchange.dart';

class XchangeService {
  late Database database;
  final String table = DBService.xRatesTable;

  XchangeService(this.database);

  Future<void> insertXchangeRate(XchangeRate xchangeRateData) async {
    await database.insert(
      table,
      xchangeRateData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<XchangeRate>> getXchangeRates() async {
    final List<Map<String, dynamic>> maps = await database.query(table);
    return List.generate(maps.length, (i) {
      return XchangeRate.fromMap(maps[i]);
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
