import 'package:sqflite/sqflite.dart';
import 'package:xtradre/model/xchange.dart';

class Migration {
  static Future<void> createRatesTable(Database database) async {
    await database.execute('''
              CREATE TABLE ${Xchange.tableName}(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              currencyPair TEXT,
              amount REAL,
              rAmount REAL,
              operator INTEGER,
              rate REAL,
              timestamp TEXT
            )
            ''');
  }
}
