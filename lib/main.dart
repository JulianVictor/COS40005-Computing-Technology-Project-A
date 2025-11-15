import 'package:flutter/material.dart';
import 'package:my_first_app/pages/cocoa_yield_input.dart';
import 'package:my_first_app/pages/cocoa_yield_management.dart';
import 'package:my_first_app/pages/welcome_page.dart';
import 'pages/record_history.dart';
import 'pages/home_dashboard.dart';
import 'cocoa_yield_management.dart';

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
      home: WelcomePage(), // <- Start here
    );
  }
}
