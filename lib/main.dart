import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xtradre/constants/colors.dart';
import 'package:xtradre/core/support/db.dart';
import 'package:xtradre/screens/transfers.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'xTradre',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: cPrimary,
          primary: cPrimary,
          secondary: cPrimary,
          background: cPrimary,
        ),
        useMaterial3: true,
      ),
      home: const Transfers(),
    );
  }
}
