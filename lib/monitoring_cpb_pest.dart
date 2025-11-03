import 'package:flutter/material.dart';
import 'home_dashboard.dart';
import 'cost_pesticide.dart';

class MonitoringCPBPest extends StatelessWidget {
  final Color purple = const Color(0xFF2D108E);

  MonitoringCPBPest({super.key});

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
        title: const Text(
          "Monitoring CPB Pest",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _monitoringCard(
              date: "29.09.2025",
              eil: "1.67",
              sample: "2",
              eggs: "13",
              decision: "TREAT",
              onDelete: () {},
            ),
            const SizedBox(height: 16),
            _monitoringCard(
              date: "-",
              eil: "-",
              sample: "-",
              eggs: "-",
              decision: "-",
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
            MaterialPageRoute(builder: (context) => const CostPesticidePage()),
          );
        },
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),

      bottomNavigationBar: Container(
        color: purple,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
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

// TEMPORARY PAGE (We will style & build this next)
class CostPesticidePage extends StatefulWidget {
  const CostPesticidePage({super.key});

  @override
  State<CostPesticidePage> createState() => _CostPesticidePageState();
}

class _CostPesticidePageState extends State<CostPesticidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D108E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Pesticide Cost Input",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text(
          "Cost Pesticide Page (Empty for now)",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

