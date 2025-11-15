import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'scan_sample.dart';

class SampleResultPage extends StatefulWidget {
  const SampleResultPage({super.key});

  @override
  State<SampleResultPage> createState() => _SampleResultPageState();
}

class _SampleResultPageState extends State<SampleResultPage> {
  final Color purple = const Color(0xFF2D108E);
  final Color grey = const Color(0xFFBDBDBD);

  // ✅ Make sure this method is inside the class, not outside
  String getCurrentDate() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}";
  }


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
        title: const Text("Sampling Result", style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ✅ Auto Date (current date)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: purple, width: 1),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('dd MMM yyyy').format(DateTime.now()), // Example: 12 Nov 2025
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Information Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle("🧴 Pesticide Information"),
                      _ItemText("Pesticide Type:", "-"),
                      _ItemText("Total Pesticide Cost (RM):", "-"),
                      _ItemText("Pesticide Price (per Liter):", "-"),
                      _ItemText("Pesticide Rate per Spray Pump (L):", "-"),

                      SizedBox(height: 12),
                      _SectionTitle("👷 Labour"),
                      _ItemText("Daily Labour Cost (RM):", "-"),
                      _ItemText("Farm Area Sprayed per Day (Hectare):", "-"),

                      SizedBox(height: 12),
                      _SectionTitle("🌱 Crop and Productivity"),
                      _ItemText("Wet Cocoa Bean Price (RM/kg):", "-"),
                      _ItemText("Wet Cocoa Bean Productivity (kg/Hectare):", "-"),

                      SizedBox(height: 12),
                      _SectionTitle("📅 Pesticide Application Frequency"),
                      _ItemText("Frequency of Pesticide Use per Year:", "-"),

                      SizedBox(height: 12),
                      _SectionTitle("📊 Economic Indicators"),
                      _ItemText("Economic Injury Level (EIL):", "-"),
                      _ItemText("Constant (K):", "-"),

                      SizedBox(height: 12),
                      _SectionTitle("🥚 Sampling Data"),
                      _ItemText("Total Samples Collected:", "-"),
                      _ItemText("Cumulative Number of CPB Eggs:", "-"),

                      SizedBox(height: 12),
                      _SectionTitle("✅ Decision"),
                      _ItemText("Action:", "-"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScanSamplePage()),
                    );
                  },
                  child: const Text(
                    "Add Sample",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Small helper widgets for cleaner code ---
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15));
  }
}

class _ItemText extends StatelessWidget {
  final String label;
  final String value;
  const _ItemText(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
