import 'package:flutter/material.dart';

class TableMonitoringCPB extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const TableMonitoringCPB({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  // Comprehensive dummy data for all filter modes
  final List<Map<String, dynamic>> cpbRecords = const [
    // Day-specific data (single days)
    {
      'date': '15.07.2024',
      'eil': '1.67',
      'sample': '2',
      'eggs': '8',
      'decision': 'TREAT',
    },
    {
      'date': '20.07.2024',
      'eil': '1.67',
      'sample': '3',
      'eggs': '2',
      'decision': 'Continue Sampling',
    },
    {
      'date': '25.07.2024',
      'eil': '1.45',
      'sample': '4',
      'eggs': '15',
      'decision': 'TREAT',
    },

    // Week data (spread across different weeks)
    {
      'date': '01.08.2024', // Week 31 (July 29 - Aug 4)
      'eil': '1.60',
      'sample': '3',
      'eggs': '5',
      'decision': 'Continue Sampling',
    },
    {
      'date': '05.08.2024', // Week 32 (Aug 5 - Aug 11)
      'eil': '1.55',
      'sample': '2',
      'eggs': '12',
      'decision': 'TREAT',
    },
    {
      'date': '12.08.2024', // Week 33 (Aug 12 - Aug 18)
      'eil': '1.70',
      'sample': '4',
      'eggs': '3',
      'decision': 'Continue Sampling',
    },

    // Month data (spread across different months)
    {
      'date': '05.06.2024', // June
      'eil': '1.50',
      'sample': '3',
      'eggs': '7',
      'decision': 'Continue Sampling',
    },
    {
      'date': '15.06.2024', // June
      'eil': '1.65',
      'sample': '2',
      'eggs': '14',
      'decision': 'TREAT',
    },
    {
      'date': '10.07.2024', // July
      'eil': '1.58',
      'sample': '4',
      'eggs': '6',
      'decision': 'Continue Sampling',
    },
    {
      'date': '20.08.2024', // August
      'eil': '1.72',
      'sample': '3',
      'eggs': '9',
      'decision': 'TREAT',
    },
    {
      'date': '05.09.2024', // September
      'eil': '1.63',
      'sample': '2',
      'eggs': '11',
      'decision': 'TREAT',
    },

    // Year data (spread across different years)
    {
      'date': '15.03.2023', // 2023
      'eil': '1.48',
      'sample': '3',
      'eggs': '4',
      'decision': 'Continue Sampling',
    },
    {
      'date': '20.06.2023', // 2023
      'eil': '1.52',
      'sample': '2',
      'eggs': '13',
      'decision': 'TREAT',
    },
    {
      'date': '10.11.2023', // 2023
      'eil': '1.59',
      'sample': '4',
      'eggs': '5',
      'decision': 'Continue Sampling',
    },
    {
      'date': '15.01.2024', // 2024
      'eil': '1.61',
      'sample': '3',
      'eggs': '8',
      'decision': 'Continue Sampling',
    },
    {
      'date': '25.04.2024', // 2024
      'eil': '1.68',
      'sample': '2',
      'eggs': '16',
      'decision': 'TREAT',
    },
    {
      'date': '30.09.2024', // 2024
      'eil': '1.54',
      'sample': '4',
      'eggs': '3',
      'decision': 'Continue Sampling',
    },
    {
      'date': '15.02.2025', // 2025
      'eil': '1.57',
      'sample': '3',
      'eggs': '10',
      'decision': 'TREAT',
    },

    // Custom range data (various dates for testing custom ranges)
    {
      'date': '01.12.2024',
      'eil': '1.66',
      'sample': '2',
      'eggs': '7',
      'decision': 'Continue Sampling',
    },
    {
      'date': '15.12.2024',
      'eil': '1.71',
      'sample': '3',
      'eggs': '18',
      'decision': 'TREAT',
    },
    {
      'date': '25.12.2024',
      'eil': '1.49',
      'sample': '4',
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
            Text(
              "Found ${filtered.length} record(s)",
              style: const TextStyle(
                fontSize: 14,
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