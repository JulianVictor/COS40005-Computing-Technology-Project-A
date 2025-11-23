
import 'package:flutter/material.dart';
import 'cocoa_yield_input.dart';
import '../models/yield_record.dart';

class CocoaYieldManagement extends StatefulWidget {
  const CocoaYieldManagement({super.key});

  @override
  State<CocoaYieldManagement> createState() => _CocoaYieldManagementState();
}

class _CocoaYieldManagementState extends State<CocoaYieldManagement> {
  // Sample data
  List<YieldRecord> records = [
    YieldRecord(
      date: '2025-10-28',
      beanType: 'Dry',
      grade: 'A',
      salesRevenue: '20',
      salesIncome: '2000',
      remarks: 'Sample record',
    ),
    YieldRecord(
      date: '2025-10-25',
      beanType: 'Wet',
      grade: 'B',
      salesRevenue: '15',
      salesIncome: '1500',
      remarks: 'Previous harvest',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cocoa Yield Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2D108E),
        foregroundColor: Colors.white,
      ),
      body: records.isEmpty
          ? const Center(
        child: Text(
          'No records yet.\nTap the + button to add one.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: records.length,
        itemBuilder: (context, index) {
          return _buildRecordCard(records[index], index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToInputPage();
        },
        backgroundColor: const Color(0xFF2D108E),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecordCard(YieldRecord record, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date
            _buildInfoRow('Date', record.date),
            const SizedBox(height: 8),

            // Cocoa Bean Type
            _buildInfoRow('Cocoa Bean Type', record.beanType),
            const SizedBox(height: 8),

            // Grade
            _buildInfoRow('Grade', record.grade),
            const SizedBox(height: 8),

            // Sales Revenue
            _buildInfoRow('Sales Revenue (kg)', record.salesRevenue),
            const SizedBox(height: 8),

            // Sales Income
            _buildInfoRow('Sales Income (RM)', record.salesIncome),

            // Edit and Delete buttons
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _editRecord(record, index),
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () => _deleteRecord(index),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToInputPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CocoaYieldInput(),
      ),
    );

    if (result != null && result is YieldRecord) {
      setState(() {
        records.add(result);
      });
    }
  }

  void _editRecord(YieldRecord record, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CocoaYieldInput(record: record),
      ),
    );

    if (result != null && result is YieldRecord) {
      setState(() {
        records[index] = result;
      });
    }
  }

  void _deleteRecord(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                records.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
