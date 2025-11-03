import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DMCOCOA Home'),
        backgroundColor: const Color(0xFF2D108E),
      ),
      body: const Center(
        child: Text(
          'Welcome to DMCOCOA!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
