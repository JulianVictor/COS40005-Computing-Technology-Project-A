import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/yield_record.dart' as yield_model;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/database_models.dart';

class CocoaYieldInput extends StatefulWidget {
  final yield_model.YieldRecord? record;
  final Farm? selectedFarm;

  const CocoaYieldInput({super.key, this.record, this.selectedFarm});

  @override
  State<CocoaYieldInput> createState() => _CocoaYieldInputState();
}

class _CocoaYieldInputState extends State<CocoaYieldInput> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _dbService = DatabaseService();

  // Form fields
  String? _selectedFarmId;
  DateTime _selectedDate = DateTime.now();
  String _selectedBeanType = 'dry';
  String _selectedGrade = 'A';
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _revenueController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  List<Map<String, dynamic>> _farms = [];
  bool _isLoadingFarms = true;

  @override
  void initState() {
    super.initState();
    _loadFarms();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.record != null) {
      // Editing existing record
      _selectedFarmId = widget.record!.farmId;
      _selectedDate = widget.record!.harvestDate;
      _selectedBeanType = widget.record!.beanType;
      _selectedGrade = widget.record!.beanGrade;
      _quantityController.text = widget.record!.quantityKg.toString();
      _revenueController.text = widget.record!.salesRevenue?.toString() ?? '';
      _remarksController.text = widget.record!.remarks ?? '';
    } else if (widget.selectedFarm != null) {
      // Adding new record with pre-selected farm
      _selectedFarmId = widget.selectedFarm!.farmId;
    }
  }

  Future<void> _loadFarms() async {
    final String? currentUserId = await _getCurrentUserId();
    if (currentUserId != null) {
      final farms = await _dbService.getUserFarmsForDropdown(currentUserId);
      setState(() {
        _farms = farms;
        _isLoadingFarms = false;

        // Auto-select logic
        if (_selectedFarmId == null) {
          if (widget.selectedFarm != null) {
            // Use the farm passed from dashboard
            _selectedFarmId = widget.selectedFarm!.farmId;
          } else if (_farms.isNotEmpty) {
            // Fallback: select first farm
            _selectedFarmId = _farms.first['farmId'];
          }
        }
      });
    } else {
      setState(() {
        _isLoadingFarms = false;
      });
    }
  }

  Future<String?> _getCurrentUserId() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      return user?.id;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<void> _saveRecord() async {
    if (_formKey.currentState!.validate() && _selectedFarmId != null) {
      final String? currentUserId = await _getCurrentUserId();

      if (currentUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      final record = yield_model.YieldRecord(
        recordId: widget.record?.recordId,
        farmerId: currentUserId,
        farmId: _selectedFarmId!,
        harvestDate: _selectedDate,
        beanType: _selectedBeanType,
        beanGrade: _selectedGrade,
        quantityKg: double.parse(_quantityController.text),
        salesRevenue: _revenueController.text.isNotEmpty
            ? double.parse(_revenueController.text)
            : null,
        remarks: _remarksController.text.isNotEmpty ? _remarksController.text : null,
      );

      try {
        if (widget.record == null) {
          await _dbService.createYieldRecord(record);
        } else {
          await _dbService.updateYieldRecord(record);
        }

        Navigator.pop(context, record);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving record: $e')),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record == null ? 'Add Yield Record' : 'Edit Yield Record'),
        backgroundColor: const Color(0xFF2D108E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveRecord,
          ),
        ],
      ),
      body: _isLoadingFarms
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Farm Selection Dropdown
              DropdownButtonFormField<String>(
                value: _selectedFarmId,
                decoration: const InputDecoration(labelText: 'Farm'),
                items: _farms.map<DropdownMenuItem<String>>((farm) {
                  return DropdownMenuItem<String>(
                    value: farm['farmId'] as String,
                    child: Text(farm['farmName'] as String),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFarmId = value;
                  });
                },
                validator: (value) {
                  if (value == null) return 'Please select a farm';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Show selected farm info if coming from dashboard
              if (widget.selectedFarm != null && _selectedFarmId == widget.selectedFarm!.farmId)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D108E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Farm: ${widget.selectedFarm!.farmName} (${widget.selectedFarm!.district}, ${widget.selectedFarm!.state})',
                    style: const TextStyle(
                      color: Color(0xFF2D108E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (widget.selectedFarm != null && _selectedFarmId == widget.selectedFarm!.farmId)
                const SizedBox(height: 16),

              // Date Picker
              ListTile(
                title: const Text('Harvest Date'),
                subtitle: Text('${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              const SizedBox(height: 16),

              // Bean Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedBeanType,
                decoration: const InputDecoration(labelText: 'Bean Type'),
                items: ['wet', 'dry'].map<DropdownMenuItem<String>>((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type == 'wet' ? 'Wet' : 'Dry'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBeanType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Grade Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGrade,
                decoration: const InputDecoration(labelText: 'Grade'),
                items: ['A', 'B', 'C'].map<DropdownMenuItem<String>>((grade) {
                  return DropdownMenuItem<String>(
                    value: grade,
                    child: Text('Grade $grade'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGrade = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Quantity Input
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity (kg)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Revenue Input (optional)
              TextFormField(
                controller: _revenueController,
                decoration: const InputDecoration(
                  labelText: 'Sales Revenue (RM) - Optional',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Remarks Input (optional)
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks - Optional',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _revenueController.dispose();
    _remarksController.dispose();
    super.dispose();
  }
}