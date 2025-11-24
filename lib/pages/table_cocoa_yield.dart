import 'package:flutter/material.dart';

class TableCocoaYield extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const TableCocoaYield({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  // Comprehensive dummy data for all filter modes - 2025 dates
  final List<Map<String, dynamic>> yieldRecords = const [
    // Day-specific data (single days in 2025)
    {
      'date': '2025-01-15',
      'beanType': 'Dry',
      'grade': 'A',
      'salesRevenue': '25',
      'salesIncome': '2500',
      'remarks': 'Excellent quality beans',
    },
    {
      'date': '2025-01-20',
      'beanType': 'Wet',
      'grade': 'B',
      'salesRevenue': '18',
      'salesIncome': '1620',
      'remarks': 'Good moisture content',
    },
    {
      'date': '2025-02-10',
      'beanType': 'Dry',
      'grade': 'AA',
      'salesRevenue': '30',
      'salesIncome': '3300',
      'remarks': 'Premium batch',
    },

    // Week data (spread across different weeks in 2025)
    {
      'date': '2025-03-03', // Week 10 (Mar 3-9)
      'beanType': 'Wet',
      'grade': 'A',
      'salesRevenue': '22',
      'salesIncome': '1980',
      'remarks': 'Standard harvest',
    },
    {
      'date': '2025-03-17', // Week 12 (Mar 17-23)
      'beanType': 'Dry',
      'grade': 'B',
      'salesRevenue': '16',
      'salesIncome': '1440',
      'remarks': 'Small batch',
    },
    {
      'date': '2025-04-07', // Week 15 (Apr 7-13)
      'beanType': 'Dry',
      'grade': 'A',
      'salesRevenue': '28',
      'salesIncome': '2800',
      'remarks': 'Consistent quality',
    },

    // Month data (spread across different months in 2025)
    {
      'date': '2025-05-05', // May
      'beanType': 'Wet',
      'grade': 'B',
      'salesRevenue': '19',
      'salesIncome': '1710',
      'remarks': 'Early season harvest',
    },
    {
      'date': '2025-05-15', // May
      'beanType': 'Dry',
      'grade': 'AA',
      'salesRevenue': '32',
      'salesIncome': '3520',
      'remarks': 'Top grade beans',
    },
    {
      'date': '2025-06-10', // June
      'beanType': 'Dry',
      'grade': 'A',
      'salesRevenue': '26',
      'salesIncome': '2600',
      'remarks': 'Main season harvest',
    },
    {
      'date': '2025-06-25', // June
      'beanType': 'Wet',
      'grade': 'C',
      'salesRevenue': '14',
      'salesIncome': '1120',
      'remarks': 'Lower grade batch',
    },
    {
      'date': '2025-07-12', // July
      'beanType': 'Dry',
      'grade': 'B',
      'salesRevenue': '17',
      'salesIncome': '1530',
      'remarks': 'Average yield',
    },

    // Second half of 2025 for variety
    {
      'date': '2025-08-08',
      'beanType': 'Wet',
      'grade': 'A',
      'salesRevenue': '24',
      'salesIncome': '2160',
      'remarks': 'Good wet beans',
    },
    {
      'date': '2025-09-18',
      'beanType': 'Dry',
      'grade': 'AA',
      'salesRevenue': '35',
      'salesIncome': '3850',
      'remarks': 'Record harvest',
    },
    {
      'date': '2025-10-25', // Your existing record
      'beanType': 'Wet',
      'grade': 'B',
      'salesRevenue': '15',
      'salesIncome': '1500',
      'remarks': 'Previous harvest',
    },
    {
      'date': '2025-10-28', // Your existing record
      'beanType': 'Dry',
      'grade': 'A',
      'salesRevenue': '20',
      'salesIncome': '2000',
      'remarks': 'Sample record',
    },
    {
      'date': '2025-11-14',
      'beanType': 'Dry',
      'grade': 'B',
      'salesRevenue': '18',
      'salesIncome': '1620',
      'remarks': 'Late season',
    },
    {
      'date': '2025-12-05',
      'beanType': 'Wet',
      'grade': 'A',
      'salesRevenue': '21',
      'salesIncome': '1890',
      'remarks': 'Year-end harvest',
    },
    {
      'date': '2025-12-20',
      'beanType': 'Dry',
      'grade': 'AA',
      'salesRevenue': '29',
      'salesIncome': '3190',
      'remarks': 'Holiday season batch',
    },

    // Additional records for better testing coverage
    {
      'date': '2025-04-22',
      'beanType': 'Wet',
      'grade': 'C',
      'salesRevenue': '12',
      'salesIncome': '960',
      'remarks': 'Training batch',
    },
    {
      'date': '2025-07-30',
      'beanType': 'Dry',
      'grade': 'A',
      'salesRevenue': '23',
      'salesIncome': '2300',
      'remarks': 'Mid-season peak',
    },
    {
      'date': '2025-09-05',
      'beanType': 'Wet',
      'grade': 'B',
      'salesRevenue': '16',
      'salesIncome': '1440',
      'remarks': 'Experimental processing',
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