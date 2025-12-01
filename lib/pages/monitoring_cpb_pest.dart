import 'package:flutter/material.dart';
import 'cost_pesticide.dart';
import 'home_dashboard.dart';

class MonitoringCPBPest extends StatefulWidget {
  const MonitoringCPBPest({super.key});

  @override
  State<MonitoringCPBPest> createState() => _MonitoringCPBPestState();
}

class _MonitoringCPBPestState extends State<MonitoringCPBPest> {
  final Color purple = const Color(0xFF2D108E);

  // List to store all monitoring records
  List<Map<String, String>> _monitoringRecords = [
    {
      'date': '29.09.2025',
      'eil': '1.67',
      'sample': '2',
      'eggs': '13',
      'decision': 'TREAT',
    },
    {
      'date': '-',
      'eil': '-',
      'sample': '-',
      'eggs': '-',
      'decision': '-',
    },
  ];

  // Function to add a new monitoring card
  void _addNewMonitoringCard() {
    setState(() {
      _monitoringRecords.add({
        'date': '-',
        'eil': '-',
        'sample': '-',
        'eggs': '-',
        'decision': '-',
      });
    });
  }

  // Function to delete a monitoring card with confirmation
  void _deleteMonitoringCard(int index) {
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
                _monitoringRecords.removeAt(index);
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

  // Function to navigate to Cost Pesticide page and wait for result
  void _navigateToCostPesticide() async {
    // Wait for result from CostPesticidePage
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CostPesticidePage(),
      ),
    );

    // If result is true, add a new monitoring card
    if (result == true) {
      _addNewMonitoringCard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "Monitoring CPB Pest",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Display all monitoring cards
            ..._monitoringRecords.asMap().entries.map((entry) {
              final index = entry.key;
              final record = entry.value;

              return Column(
                children: [
                  _monitoringCard(
                    date: record['date']!,
                    eil: record['eil']!,
                    sample: record['sample']!,
                    eggs: record['eggs']!,
                    decision: record['decision']!,
                    onDelete: () => _deleteMonitoringCard(index), onEdit: () {  },
                  ),
                  if (index < _monitoringRecords.length - 1)
                    const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ],
        ),
      ),

      // FAB navigates to Cost Pesticide page
      floatingActionButton: FloatingActionButton(
        backgroundColor: purple,
        onPressed: _navigateToCostPesticide,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),

      bottomNavigationBar: Container(
        color: purple,
        height: 60,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.menu, color: Colors.white),
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.person, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _monitoringCard({
    required String date,
    required String eil,
    required String sample,
    required String eggs,
    required String decision,
    required VoidCallback onDelete, required Null Function() onEdit,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("EIL: $eil"),
                  const SizedBox(height: 4),
                  Text("Total Sample: $sample"),
                  const SizedBox(height: 4),
                  Text("Cumulative No. of CPB Eggs: $eggs"),
                  const SizedBox(height: 4),
                  Text("Decision: $decision"),
                ],
              ),
            ),
            // Delete button only - changed to filled bin icon
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}