import 'package:flutter/material.dart';

class SampleResultPage extends StatefulWidget {
  const SampleResultPage({super.key});

  @override
  State<SampleResultPage> createState() => _SampleResultPageState();
}

class _SampleResultPageState extends State<SampleResultPage> {
  final Color purple = const Color(0xFF2D108E);

  List<int> samples = []; // Stores total eggs per sample
  double eil = 11.59; // Later this will come from previous page or admin
  int maxSamples = 10;

  void _addSample() {
    if (samples.length >= maxSamples) return;

    final TextEditingController eggController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter CPB Eggs Count"),
        content: TextField(
          controller: eggController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "eggs count (e.g., 3)",
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: purple),
            child: const Text("Save"),
            onPressed: () {
              int eggs = int.tryParse(eggController.text) ?? 0;
              setState(() => samples.add(eggs));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int cumulative = samples.fold(0, (a, b) => a + b);
    double average = samples.isNotEmpty ? cumulative / samples.length : 0;
    bool treat = average >= eil;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: purple,
        centerTitle: true,
        title: const Text("Sampling Result", style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Decision Display
            if (samples.isNotEmpty) ...[
              const Text("Decision:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                treat ? "Treat" : "Continue taking sample",
                style: TextStyle(
                  color: treat ? Colors.red : Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Sample List
            Expanded(
              child: ListView.builder(
                itemCount: samples.length,
                itemBuilder: (_, index) {
                  int sampleNumber = index + 1;
                  int eggs = samples[index];
                  double avg = (cumulative / sampleNumber);

                  bool treatThis = avg >= eil;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sample $sampleNumber", style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              treatThis ? "Treat" : "Continue taking sample",
                              style: TextStyle(
                                color: treatThis ? Colors.red : Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("$eggs", style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(avg.toStringAsFixed(2)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: _addSample,
                    child: const Text("Add Sample", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
