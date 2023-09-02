import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

mixin DBService {
  static const String xRatesTable = 'xchanges';

  static Future<void> migrate() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'xchanges.db');
    bool exists = await databaseExists(path);

    if (!exists) {
      try {
        await openDatabase(
          path,
          version: 1,
          onCreate: (Database db, int version) {
            db.execute('''
              CREATE TABLE xRatesTable(
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
  }
}
