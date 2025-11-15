import 'package:flutter/material.dart';

class TableMonitoringCPB extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const TableMonitoringCPB({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitoring CPB Pest"),
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
