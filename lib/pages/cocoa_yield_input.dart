import 'package:flutter/material.dart';
import '../models/yield_record.dart';

class CocoaYieldInput extends StatefulWidget {
  final YieldRecord? record;

  const CocoaYieldInput({super.key, this.record});

  @override
  State<CocoaYieldInput> createState() => _CocoaYieldInputState();
}

class _CocoaYieldInputState extends State<CocoaYieldInput> {
  final TextEditingController _dateController = TextEditingController();
  String? _selectedBeanType;
  String? _selectedGrade;
  final TextEditingController _revenueController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  // Dropdown options
  final List<String> _beanTypes = ['Wet', 'Dry'];
  final List<String> _grades = ['A', 'B', 'C'];

  @override
  void initState() {
    super.initState();
    // If editing existing record, populate fields
    if (widget.record != null) {
      _dateController.text = widget.record!.date;
      _selectedBeanType = widget.record!.beanType;
      _selectedGrade = widget.record!.grade;
      _revenueController.text = widget.record!.salesRevenue;
      _incomeController.text = widget.record!.salesIncome;
      _remarksController.text = widget.record!.remarks;
    } else {
      // Set default date to today for new records
      final now = DateTime.now();
      _dateController.text = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cocoa Yield Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2D108E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Picker
            _buildDateField(),
            const SizedBox(height: 20),

            // Cocoa Bean Type Dropdown
            _buildDropdownField(
              label: 'Cocoa Bean Type',
              value: _selectedBeanType,
              items: _beanTypes,
              onChanged: (value) {
                setState(() {
                  _selectedBeanType = value;
                });
              },
              hint: 'Select bean type',
            ),
            const SizedBox(height: 16),

            // Grade Dropdown
            _buildDropdownField(
              label: 'Grade',
              value: _selectedGrade,
              items: _grades,
              onChanged: (value) {
                setState(() {
                  _selectedGrade = value;
                });
              },
              hint: 'Select grade',
            ),
            const SizedBox(height: 16),

            // Sales Revenue (kg)
            _buildNumberField(
              label: 'Sales Revenue (kg)',
              controller: _revenueController,
              hint: '0',
            ),
            const SizedBox(height: 16),

            // Sales Income (RM)
            _buildNumberField(
              label: 'Sales Income (RM)',
              controller: _incomeController,
              hint: '0',
            ),
            const SizedBox(height: 16),

            // Remarks
            _buildRemarksField(),
            const SizedBox(height: 30),

            // Save Button
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFF2D108E)),
            const SizedBox(width: 12),
            Text(
              _dateController.text.isEmpty ? 'Select Date' : _dateController.text,
              style: TextStyle(
                color: _dateController.text.isEmpty ? Colors.grey : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text(hint),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Color(0xFF2D108E)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRemarksField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Remarks',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _remarksController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter any remarks...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Color(0xFF2D108E)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _saveRecord,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D108E),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Save Record',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _saveRecord() {
    // Validation
    if (_dateController.text.isEmpty) {
      _showError('Please select a date');
      return;
    }
    if (_selectedBeanType == null) {
      _showError('Please select cocoa bean type');
      return;
    }
    if (_selectedGrade == null) {
      _showError('Please select grade');
      return;
    }
    if (_revenueController.text.isEmpty) {
      _showError('Please enter sales revenue');
      return;
    }
    if (_incomeController.text.isEmpty) {
      _showError('Please enter sales income');
      return;
    }

    final record = YieldRecord(
      date: _dateController.text,
      beanType: _selectedBeanType!,
      grade: _selectedGrade!,
      salesRevenue: _revenueController.text,
      salesIncome: _incomeController.text,
      remarks: _remarksController.text, salesRSevenue: '',
    );

    Navigator.pop(context, record);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _revenueController.dispose();
    _incomeController.dispose();
    _remarksController.dispose();
    super.dispose();
  }
}