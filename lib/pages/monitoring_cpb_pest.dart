import 'package:flutter/material.dart';
import 'home.dart';
import 'cost_pesticide.dart';
import '../models/database_models.dart'; // Add this import

class MonitoringCPBPest extends StatelessWidget {
  final Color purple = const Color(0xFF2D108E);
  final Farm farm; // Add this

  const MonitoringCPBPest({
    super.key,
    required this.farm, // Add this
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              "Monitoring CPB Pest",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              farm.farmName, // Show farm name
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // You can now use farm data in your cards
            _monitoringCard(
              farmName: farm.farmName, // Pass farm name
              date: "29.09.2025",
              eil: "1.67",
              sample: "2",
              eggs: "13",
              decision: "TREAT",
              onDelete: () {},
            ),
            const SizedBox(height: 16),
            _monitoringCard(
              farmName: farm.farmName, // Pass farm name
              date: "10.10.2025",
              eil: "1.67",
              sample: "3",
              eggs: "2",
              decision: "Continue Sampling",
              onDelete: () {},
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: purple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CostPesticidePage(), // Pass farm to next page if needed
            ),
          );
        },
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
    required String farmName, // Add farmName parameter
    required String date,
    required String eil,
    required String sample,
    required String eggs,
    required String decision,
    required VoidCallback onDelete,
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
                  Text("Farm: $farmName", style: const TextStyle(fontWeight: FontWeight.bold)), // Show farm name
                  const SizedBox(height: 4),
                  Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("EIL: $eil"),
                  Text("Total Sample: $sample"),
                  Text("Cumulative No. of CPB Eggs: $eggs"),
                  Text("Decision: $decision"),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}