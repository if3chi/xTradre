import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xtradre/Core/Support/db.dart';
import 'package:xtradre/screens/xchange_rate_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await DBService.init();

  runApp(XTradre(db));
}

class XTradre extends StatelessWidget {
  final Database db;

  const XTradre(this.db, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xTradre',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: XchangeRateScreen(db),
    );
  }
}
