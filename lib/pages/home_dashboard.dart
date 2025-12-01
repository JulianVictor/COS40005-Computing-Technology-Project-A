import 'package:flutter/material.dart';
import 'monitoring_cpb_pest.dart';
import 'cocoa_yield_management.dart';
import 'record_history.dart';
import '../models/farm_selection_models.dart'; // ADD THIS IMPORT

class HomeDashboard extends StatelessWidget {
  final FarmSelection farm; // CHANGE: Add this parameter
  final Function(FarmSelection) onFarmSelected; // CHANGE: Add this parameter

  // KEEP your existing parameters with default values
  final String farmName;
  final double latitude;
  final double longitude;
  final int treeStands;
  final int latestEggCount;
  final bool needsTreatment;

  const HomeDashboard({
    super.key,
    required this.farm, // ADD: Required parameter
    required this.onFarmSelected, // ADD: Required parameter
    this.farmName = "My Farm",
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.treeStands = 0,
    this.latestEggCount = 0,
    this.needsTreatment = false,
  });

  final Color purple = const Color(0xFF2D108E);

  @override
  Widget build(BuildContext context) {
    // Use the farm data here
    final actualFarmName = farm.farmName;
    final actualTreeStands = farm.treeCount;
    // ... more if needed

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: purple,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "DMCOCOA",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display actual farm name from the FarmSelection object
            Text(
              "Farm: ${farm.farmName}", // Use farm.farmName
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            const Text(
              "Record of Last CPB Pest Monitoring",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Farm: ${farm.farmName}"),
                  Text("Location: ${farm.state}, ${farm.district}"),
                  Text("Area: ${farm.areaHectares} hectares"),
                  Text("Tree Stands: ${farm.treeCount}"),
                  const SizedBox(height: 10),
                  const Text("Date     : 01.09.2021"),
                  const SizedBox(height: 6),
                  const Text("Decision : TREAT"),
                  const SizedBox(height: 6),
                  const Text("Remark  : Reuse DMCOCOA on 11.09.2021"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _mainButton("Monitoring of CPB Pest", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MonitoringCPBPest()),
              );
            }),
            const SizedBox(height: 12),

            _mainButton("Cocoa Yield Management", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CocoaYieldManagement()),
              );
            }),
            const SizedBox(height: 12),

            _mainButton("Record History", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecordHistory()),
              );
            }),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        height: 60,
        color: purple,
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
}

// Styled Main Button
Widget _mainButton(String title, VoidCallback onTap) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2D108E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onTap,
      child: Text(title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
    ),
  );
}