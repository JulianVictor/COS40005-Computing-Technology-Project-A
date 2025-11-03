import 'package:flutter/material.dart';
import 'record_history.dart';
import 'home_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocoa Farm App',
      debugShowCheckedModeBanner: false,
      home: HomeDashboard(), // <- Start here
    );
  }
}
