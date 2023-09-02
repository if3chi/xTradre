import 'package:flutter/material.dart';
import 'package:xtradre/screens/home.dart';
import 'package:xtradre/Service/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBService.migrate();

  runApp(const XTradre());
}

class XTradre extends StatelessWidget {
  const XTradre({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xTradre',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const XchangeRateScreen(),
    );
  }
}
