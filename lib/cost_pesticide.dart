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

  void _calculateCost() {
    double price = double.tryParse(priceController.text) ?? 0;
    double pumps = double.tryParse(sprayPumpController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;

    setState(() {
      pesticideCost = price * pumps * rate;
    });
  }

  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: purple),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  @override
  void initState() {
    super.initState();
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
          onPressed: () => Navigator.pop(context),
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

              // ✅ Date Selector (Figma Style)
              Center(
                child: GestureDetector(
                  onTap: _pickDate,
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
                        Text(formatDate(selectedDate),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
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
                  Expanded(child: _bottomButton("Previous", purple, () => Navigator.pop(context))),
                  const SizedBox(width: 10),
                  Expanded(child: _bottomButton("Draft", Colors.grey.shade600, () {})),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _bottomButton("Next", purple, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LabourCostPage()), // Fixed class name
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
