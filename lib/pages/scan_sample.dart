import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScanSamplePage extends StatefulWidget {
  final int sampleNumber; // Passed from previous page
  const ScanSamplePage({super.key, this.sampleNumber = 1});

  @override
  State<ScanSamplePage> createState() => _ScanSamplePageState();
}

class _ScanSamplePageState extends State<ScanSamplePage> {
  final Color purple = const Color(0xFF2D108E);

  late int sampleNumber;
  double average = 0;
  int cumulative = 0;
  double eil = 11.59;

  // 5 pods data
  List<int> podResults = List.filled(5, 0);

  @override
  void initState() {
    super.initState();
    sampleNumber = widget.sampleNumber;
  }

  String getCurrentDate() {
    return DateFormat('dd.MM.yyyy').format(DateTime.now());
  }

  void _updateResults() {
    setState(() {
      cumulative = podResults.reduce((a, b) => a + b);
      average = cumulative / podResults.length;
    });
  }

  // Placeholder for AI scanning logic
  Future<void> _scanPod(int index) async {
    // 🧠 Later this will use camera + AI model to detect eggs
    // For now we just simulate detected egg count
    setState(() {
      podResults[index] = (1 + index * 2); // dummy data for testing
    });
    _updateResults();
  }

  @override
  Widget build(BuildContext context) {
    bool treat = average >= eil;

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
          "Sampling Result",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🕒 Real-time date
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
            const SizedBox(height: 20),

            _label("Sample"),
            _readonlyBox(sampleNumber.toString()),

            _label("Cumulative No. of CPB Eggs"),
            _readonlyBox(cumulative.toString()),

            _label("Average CPB Eggs/Sample"),
            _readonlyBox(average.toStringAsFixed(2)),

            _label("Number of CPB Eggs/Pod"),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (i) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i < 4 ? 6 : 0),
                    child: GestureDetector(
                      onTap: () => _scanPod(i),
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_alt_outlined,
                                size: 26, color: Colors.grey),
                            const SizedBox(height: 3),
                            Text(
                              podResults[i].toString(),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            const Text(
              "Decision:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sample $sampleNumber",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      treat ? "Treat" : "Continue taking sample",
                      style: TextStyle(
                          color: treat ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(cumulative.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      average.toStringAsFixed(2),
                      style: TextStyle(
                        color: treat ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bottomButton("Previous", purple, () => Navigator.pop(context)),
                const SizedBox(width: 10),
                _bottomButton("Draft", Colors.grey.shade600, () {}),
                const SizedBox(width: 10),
                _bottomButton("Submit", purple, () {
                  Navigator.pop(context, {
                    "totalEggs": cumulative,
                    "average": average,
                    "decision": average >= eil ? "Treat" : "Continue taking sample",
                    "pods": podResults,
                  });
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper Widgets
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 6),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
    ),
  );

  Widget _readonlyBox(String value) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: value,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }

  Widget _bottomButton(String text, Color color, VoidCallback onTap) {
    return Expanded(
      child: SizedBox(
        height: 45,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: onTap,
          child: Text(text,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }
}
