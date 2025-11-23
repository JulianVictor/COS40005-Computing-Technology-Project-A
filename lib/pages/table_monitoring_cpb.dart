import 'package:flutter/material.dart';

class TableMonitoringCPB extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const TableMonitoringCPB({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  // Dummy data based on monitoring_cpb_pest.dart
  final List<Map<String, dynamic>> cpbRecords = const [
    {
      'date': '29.09.2025',
      'eil': '1.67',
      'sample': '2',
      'eggs': '13',
      'decision': 'TREAT',
    },
    {
      'date': '10.10.2025',
      'eil': '1.67',
      'sample': '3',
      'eggs': '2',
      'decision': 'Continue Sampling',
    },
  ];

  List<Map<String, dynamic>> get filteredRecords {
    return cpbRecords.where((record) {
      final recordDate = _parseDate(record['date']);
      return (recordDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          recordDate.isBefore(endDate.add(const Duration(days: 1))));
    }).toList();
  }

  DateTime _parseDate(String dateString) {
    final parts = dateString.split('.');
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredRecords;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitoring CPB Pest Records"),
      ),
      body: filtered.isEmpty
          ? Center(
        child: Text(
          "No data found for selected date range\n\nFrom: ${_formatDate(startDate)}\nTo: ${_formatDate(endDate)}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Records from ${_formatDate(startDate)} to ${_formatDate(endDate)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final record = filtered[index];
                  return _buildRecordCard(record);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  record['date'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDecisionColor(record['decision']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    record['decision'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow("EIL (Economic Injury Level):", record['eil']),
            _buildInfoRow("Total Samples:", record['sample']),
            _buildInfoRow("Cumulative CPB Eggs:", record['eggs']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDecisionColor(String decision) {
    switch (decision) {
      case 'TREAT':
        return Colors.red;
      case 'Continue Sampling':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }
}