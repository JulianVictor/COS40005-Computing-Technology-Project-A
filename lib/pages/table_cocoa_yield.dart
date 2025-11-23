import 'package:flutter/material.dart';

class TableCocoaYield extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const TableCocoaYield({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  // Dummy data based on cocoa_yield_management.dart
  final List<Map<String, dynamic>> yieldRecords = const [
    {
      'date': '2025-10-28',
      'beanType': 'Dry',
      'grade': 'A',
      'salesRevenue': '20',
      'salesIncome': '2000',
      'remarks': 'Sample record',
    },
    {
      'date': '2025-10-25',
      'beanType': 'Wet',
      'grade': 'B',
      'salesRevenue': '15',
      'salesIncome': '1500',
      'remarks': 'Previous harvest',
    },
  ];

  List<Map<String, dynamic>> get filteredRecords {
    return yieldRecords.where((record) {
      final recordDate = _parseDate(record['date']);
      return (recordDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          recordDate.isBefore(endDate.add(const Duration(days: 1))));
    }).toList();
  }

  DateTime _parseDate(String dateString) {
    final parts = dateString.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredRecords;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cocoa Yield Management Records"),
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
                    color: _getBeanTypeColor(record['beanType']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    record['beanType'],
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
            _buildInfoRow("Grade:", record['grade']),
            _buildInfoRow("Sales Revenue:", "${record['salesRevenue']} kg"),
            _buildInfoRow("Sales Income:", "RM ${record['salesIncome']}"),
            if (record['remarks'] != null && record['remarks'].isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow("Remarks:", record['remarks']),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBeanTypeColor(String beanType) {
    switch (beanType) {
      case 'Dry':
        return Colors.orange;
      case 'Wet':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}