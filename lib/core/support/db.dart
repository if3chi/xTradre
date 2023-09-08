import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xtradre/core/support/migrations.dart';

class DBService {
  static const String database = 'xtradre.db';

  static Future<Database> init() async {
    return openDatabase(
      await dbPath,
      version: 1,
      onCreate: (Database db, int version) {
        Migration.createRatesTable(db);
      },
    );
  }

  static Future<String> get dbPath async =>
      join(await getDatabasesPath(), database);
}
