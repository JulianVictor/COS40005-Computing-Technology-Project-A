import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'labour_cost.dart';

class CostPesticidePage extends StatefulWidget {
  const CostPesticidePage({super.key});

  @override
  State<CostPesticidePage> createState() => _CostPesticidePageState();
}

class _CostPesticidePageState extends State<CostPesticidePage> {
  final Color purple = const Color(0xFF2D108E);

  DateTime selectedDate = DateTime.now();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController sprayPumpController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  double pesticideCost = 0.0;

  String formatDate(DateTime date) => DateFormat("dd MMM yyyy").format(date);

// DUMMY DATA - Pre-filled values for testing
  final Map<String, dynamic> dummyData = {
    'brand': 'ABCDE',
    'price': 100.0,
    'sprayPumps': 2.0,
    'rate': 3.0,
  };

  void _calculateCost() {
    double price = double.tryParse(priceController.text) ?? 0;
    double pumps = double.tryParse(sprayPumpController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;

    setState(() {
      pesticideCost = price * pumps * rate;
    });
  }

  @override
  void initState() {
    super.initState();

    // DUMMY DATA: Pre-fill the text fields with dummy values
    brandController.text = dummyData['brand'];
    priceController.text = dummyData['price'].toString();
    sprayPumpController.text = dummyData['sprayPumps'].toString();
    rateController.text = dummyData['rate'].toString();

    // Calculate initial cost based on dummy data
    pesticideCost = dummyData['price'] * dummyData['sprayPumps'] * dummyData['rate'];

    priceController.addListener(_calculateCost);
    sprayPumpController.addListener(_calculateCost);
    rateController.addListener(_calculateCost);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, false), // Return false when back
        ),
        centerTitle: true,
        title: const Text(
          "Pesticide Cost",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Date Display (Non-interactive)
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

              _label("Brand of Pesticide"),
              _inputField(brandController),

              _label("Price of Pesticide (RM/Liter)"),
              _inputField(priceController, keyboard: TextInputType.number),

              _label("Number of Spray Pump Required (per Hectare)"),
              _inputField(sprayPumpController, keyboard: TextInputType.number),

              _label("Pesticide Rate per Spray Pump (Liter)"),
              _inputField(rateController, keyboard: TextInputType.number),

              _label("Pesticide Cost (RM)"),
              _readOnlyField(pesticideCost.toStringAsFixed(2)),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(child: _bottomButton("Previous", purple, () => Navigator.pop(context, false))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _bottomButton("Next", purple, () {
                      // Return true when Next is pressed to create new box
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LabourCostPage()),
                      ).then((_) {
                        // When returning from LabourCostPage, pop with true
                        Navigator.pop(context, true);
                      });
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _readOnlyField(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _bottomButton(String text, Color color, VoidCallback onTap) {
    return SizedBox(
      width: 100,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}