import 'package:flutter/material.dart';
import 'package:xtradre/screens/home.dart';

void main() {
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
