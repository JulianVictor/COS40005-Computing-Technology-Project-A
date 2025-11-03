import 'package:dm_cocoa_app/pages/cocoa_yield_input.dart';
import 'package:flutter/material.dart';
import 'pages/cocoa_yield_management.dart';
import 'pages/login.dart';
import 'pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DMCOCOA',
      theme: ThemeData(
        primaryColor: const Color(0xFF2D108E),
        useMaterial3: true,
      ),
      home: const Login(),
      routes: {
        '/home': (context) => const HomePage(),
        '/cocoa-yield': (context) => const CocoaYieldManagement(),
        '/cocoa-yield-input': (context) => const CocoaYieldInput(),
      },
    );
  }
}