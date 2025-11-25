import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sample_result.dart';
import 'cost_pesticide.dart'; // Add this import

class LabourCostPage extends StatefulWidget {
  const LabourCostPage({super.key});

  @override
  State<LabourCostPage> createState() => _DailyLabourCostPageState();
}

class _DailyLabourCostPageState extends State<LabourCostPage> {
  final Color purple = const Color(0xFF2D108E);

  DateTime selectedDate = DateTime.now();
  final TextEditingController labourCostController = TextEditingController();
  final TextEditingController farmAreaController = TextEditingController();
  final TextEditingController workCostController = TextEditingController();
  final TextEditingController beansPriceController = TextEditingController();
  final TextEditingController beansProductivityController = TextEditingController();
  final TextEditingController kController = TextEditingController();

  String formatDate(DateTime date) => DateFormat("dd MMM yyyy").format(date);

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
          "Daily Labour Cost",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Display (Non-interactive) - Added from Pesticide page
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: purple),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, size: 18, color: Colors.black87),
                      const SizedBox(width: 10),
                      Text(formatDate(DateTime.now()), // Always show current date
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _label("Daily Labour Cost (RM)"),
              const SizedBox(height: 6),
              _inputField(labourCostController, keyboard: TextInputType.number),
              const SizedBox(height: 16),

              _label("Farm Area Sprayed / Days (Hectare)"),
              _inputField(farmAreaController, keyboard: TextInputType.number),

              _label("Work Cost / Day (Hectare)"),
              _readOnlyField(workCostController),

              _label("Wet Cocoa Beans Price (RM/kg)"),
              _inputField(beansPriceController, keyboard: TextInputType.number),

              _label("Wet Cocoa Beans Productivity (kg/Hectare)"),
              _inputField(beansProductivityController, keyboard: TextInputType.number),

              _label("K (Proportionate Reduction in Injury)"),
              _readOnlyField(kController),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: _bottomButton("Previous", purple, () {
                      // Navigate back to Pesticide Cost page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const CostPesticidePage()),
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _bottomButton("Next", purple, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SampleResultPage()),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
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

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
  );

  Widget _inputField(TextEditingController controller, {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: purple, width: 2),
        ),
      ),
    );
  }

  Widget _bottomButton(String text, Color color, VoidCallback onTap) {
    return Expanded(
      child: SizedBox(
        height: 50,
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
              style: const TextStyle(color: Colors.white, fontSize: 16)
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    labourCostController.addListener(_calculateWorkCost);
    farmAreaController.addListener(_calculateWorkCost);

    // Example default K value (set by admin later)
    kController.text = "0.8";
  }

  Widget _readOnlyField(TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F5F5), // Light grey background
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  void _calculateWorkCost() {
    double labour = double.tryParse(labourCostController.text) ?? 0;
    double area = double.tryParse(farmAreaController.text) ?? 1; // avoid divide by zero

    double result = labour / area;
    workCostController.text = result.isFinite ? result.toStringAsFixed(2) : "0.00";
  }
}