import 'package:flutter/material.dart';

class TableCocoaYield extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const TableCocoaYield({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cocoa Yield Management"),
      ),
      body: Center(
        child: Text(
          "No data found\n\nFrom: $startDate\nTo: $endDate",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
