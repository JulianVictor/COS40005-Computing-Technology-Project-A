import 'package:flutter/material.dart';

class TableMonitoringCPB extends StatelessWidget {
  final Color purple = const Color(0xFF2D108E);

  // Example data — later you will replace this with Supabase data
  final List<Map<String, dynamic>> records = [
    {
      "date": "01.01.2025",
      "samples": 1,
      "eggs": 100,
      "decision": "Treat",
    },
    {
      "date": "02.01.2025",
      "samples": 2,
      "eggs": 300,
      "decision": "Continue taking sample",
    },
  ];

  TableMonitoringCPB({super.key});

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
        title: const Text(
          "Monitoring CPB Pest",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.file_download, color: Colors.white),
          ),
        ],
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // **horizontal scroll**
        child: Column(
          children: [
            _tableHeader(),

            // **Vertical scroll for rows**
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(records.length, (index) {
                    final row = records[index];
                    return _tableRow(
                      index: index,
                      date: row["date"],
                      samples: row["samples"].toString(),
                      eggs: row["eggs"].toString(),
                      decision: row["decision"],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // HEADER ROW
  // ---------------------------
  Widget _tableHeader() {
    return Container(
      color: purple.withOpacity(0.1),
      child: Row(
        children: [
          _headerCell("Date", 120),
          _headerCell("Total Sample (s)", 150),
          _headerCell("Cumulative\nNo. of CPB Eggs", 180),
          _headerCell("Decision", 200),
        ],
      ),
    );
  }

  Widget _headerCell(String title, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // ---------------------------
  // DATA ROWS
  // ---------------------------
  Widget _tableRow({
    required int index,
    required String date,
    required String samples,
    required String eggs,
    required String decision,
  }) {
    return Container(
      color: index % 2 == 0 ? Colors.white : Colors.grey.shade100,
      child: Row(
        children: [
          _cell(date, 120),
          _cell(samples, 150),
          _cell(eggs, 180),
          _cell(decision, 200),
        ],
      ),
    );
  }

  Widget _cell(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
