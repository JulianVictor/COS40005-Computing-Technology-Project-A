import 'package:flutter/material.dart';
import 'monitoring_cpb_pest.dart';
import 'cocoa_yield_management.dart';
import 'record_history.dart';

class HomeDashboard extends StatelessWidget {
  final String farmName;
  final double latitude;
  final double longitude;
  final int treeStands;
  final int latestEggCount;
  final bool needsTreatment;

  const HomeDashboard({
    super.key,
    this.farmName = "My Farm",           // Added default value
    this.latitude = 0.0,                 // Added default value
    this.longitude = 0.0,                // Added default value
    this.treeStands = 0,                 // Added default value
    this.latestEggCount = 0,             // Added default value
    this.needsTreatment = false,         // Added default value
  });

  final Color purple = const Color(0xFF2D108E);

  @override
  Widget build(BuildContext context) {
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date     : 01.09.2021"),
                  SizedBox(height: 6),
                  Text("Decision : TREAT"),
                  SizedBox(height: 6),
                  Text("Remark  : Reuse DMCOCOA on 11.09.2021"),
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

// ✅ Styled Main Button
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
