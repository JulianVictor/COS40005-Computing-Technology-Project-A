import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'scan_sample.dart';
import 'labour_cost.dart';

class SampleResultPage extends StatefulWidget {
  const SampleResultPage({super.key, required Map<String, Object> scanData});

  @override
  State<SampleResultPage> createState() => _SampleResultPageState();
}

class _SampleResultPageState extends State<SampleResultPage> {
  final Color purple = const Color(0xFF2D108E);
  final Color grey = const Color(0xFFBDBDBD);

  // DUMMY DATA - All collected information
  final Map<String, dynamic> pesticideData = {
    'brand': 'ABCDE',
    'price': 100.0,
    'sprayPumps': 2.0,
    'rate': 3.0,
    'totalCost': 600.0,
  };

  final Map<String, dynamic> labourData = {
    'dailyLabourCost': 200.0,
    'farmArea': 2.0,
    'workCost': 100.0,
    'beansPrice': 150.0,
    'beansProductivity': 160.0,
    'kValue': 0.8,
  };

  // DUMMY DATA - Sample history (Sample 2 at top, Sample 1 at bottom)
  final List<Map<String, dynamic>> sampleHistory = [
    {
      'sampleNumber': 2,
      'cumulativeEggs': 8,
      'average': 1.60,
      'decision': 'TREAT',
      'decisionColor': Colors.red,
    },
    {
      'sampleNumber': 1,
      'cumulativeEggs': 7,
      'average': 1.40,
      'decision': 'Continue taking sample',
      'decisionColor': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ScanSamplePage()),
            );
          },
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

              // Date Display
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
                        DateFormat('dd MMM yyyy').format(DateTime.now()),
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

              // Information Card with DUMMY DATA
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionTitle("🧪 Pesticide Cost"),
                      _ItemText("Brand of Pesticide:", pesticideData['brand']),
                      _ItemText("Price of Pesticide (RM/L):", pesticideData['price'].toStringAsFixed(0)),
                      _ItemText("Number of Spray Pump Required (/H):", pesticideData['sprayPumps'].toStringAsFixed(0)),
                      _ItemText("Pesticide Rate per Spray Pump (L):", pesticideData['rate'].toStringAsFixed(0)),
                      _ItemText("Pesticide Cost (RM):", pesticideData['totalCost'].toStringAsFixed(0)),

                      const SizedBox(height: 12),
                      const _SectionTitle("👨‍🌾 Daily Labour Cost"),
                      _ItemText("Daily Labour Cost (RM):", labourData['dailyLabourCost'].toStringAsFixed(0)),
                      _ItemText("Farm Area Sprayed per Day (H):", labourData['farmArea'].toStringAsFixed(0)),
                      _ItemText("Work Cost / Day (H):", labourData['workCost'].toStringAsFixed(0)),
                      _ItemText("Wet Cocoa Bean Price (RM/kg):", labourData['beansPrice'].toStringAsFixed(0)),
                      _ItemText("Wet Cocoa Bean Productivity (kg/H):", labourData['beansProductivity'].toStringAsFixed(0)),
                      _ItemText("K (Proportionate Reduction In Injury):", labourData['kValue'].toStringAsFixed(1)),

                    ],
                  ),
                ),
              ),

              // Sample History Cards
              ...sampleHistory.map((sample) {
                return Card(
                  margin: const EdgeInsets.only(top: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sample ${sample['sampleNumber']}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              sample['decision'], // SWITCHED: Decision text on left
                              style: TextStyle(
                                color: sample['decisionColor'],
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              sample['cumulativeEggs'].toString(), // SWITCHED: Egg count on right
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              sample['average'].toStringAsFixed(2), // SWITCHED: Average on right
                              style: TextStyle(
                                color: sample['decisionColor'],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 30),

              // Navigation Buttons
              Row(
                children: [
                  Expanded(
                    child: _bottomButton("Previous", purple, () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ScanSamplePage()),
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _bottomButton("Add Sample", purple, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ScanSamplePage()),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bottom button widget
  Widget _bottomButton(String text, Color color, VoidCallback onTap) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

// Helper widgets
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