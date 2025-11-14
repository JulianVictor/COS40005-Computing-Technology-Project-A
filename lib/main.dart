import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';


void main() {
  runApp(const DmCocoaApp());
}

class DmCocoaApp extends StatelessWidget {
  const DmCocoaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'dmCocoaApp',
      theme: ThemeData(
        primaryColor: const Color(0xFFD9D9D9),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const WelcomePage(),
    );
  }
}
