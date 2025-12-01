import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cocoa_yield_input.dart';
import '../models/yield_record.dart' as yield_model;
import '../models/database_models.dart';
import '../services/cocoa_yield_service.dart';

class CocoaYieldManagement extends StatefulWidget {
  final Farm? selectedFarm;

  const CocoaYieldManagement({super.key, this.selectedFarm});

  @override
  State<CocoaYieldManagement> createState() => _CocoaYieldManagementState();
}

class _CocoaYieldManagementState extends State<CocoaYieldManagement> {
  final CocoaYieldService _yieldService = CocoaYieldService();
  List<yield_model.YieldRecord> records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final String? currentUserId = await _getCurrentUserId();
    if (currentUserId != null) {
      // Use the selected farm ID if available, otherwise get all farms
      final yieldRecords = await _yieldService.getYieldRecords(
        currentUserId,
        farmId: widget.selectedFarm?.farmId,
      );
      setState(() {
        records = yieldRecords;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cocoa Yield Management',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.selectedFarm != null)
              Text(
                widget.selectedFarm!.farmName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        backgroundColor: const Color(0xFF2D108E),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : records.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.agriculture_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              widget.selectedFarm != null
                  ? 'No yield records for ${widget.selectedFarm!.farmName}'
                  : 'No yield records yet',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the + button to add one.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: records.length,
        itemBuilder: (context, index) {
          return _buildRecordCard(records[index], index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToInputPage();
        },
        backgroundColor: const Color(0xFF2D108E),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecordCard(yield_model.YieldRecord record, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Farm Name (if we have the farm data)
            if (widget.selectedFarm != null)
              _buildInfoRow('Farm', widget.selectedFarm!.farmName),
            if (widget.selectedFarm == null)
              _buildInfoRow('Farm ID', record.farmId),
            const SizedBox(height: 8),

            // Date
            _buildInfoRow('Date',
                '${record.harvestDate.year}-${record.harvestDate.month}-${record.harvestDate.day}'),
            const SizedBox(height: 8),

            // Cocoa Bean Type
            _buildInfoRow('Cocoa Bean Type', record.beanType.toUpperCase()),
            const SizedBox(height: 8),

            // Grade
            _buildInfoRow('Grade', 'Grade ${record.beanGrade}'),
            const SizedBox(height: 8),

            // Quantity (kg)
            _buildInfoRow('Quantity (kg)', record.quantityKg.toStringAsFixed(2)),
            const SizedBox(height: 8),

            // Sales Income (RM) - only show if exists
            if (record.salesRevenue != null) ...[
              _buildInfoRow('Sales Income (RM)', record.salesRevenue!.toStringAsFixed(2)),
              const SizedBox(height: 8),
            ],

            // Remarks - only show if exists
            if (record.remarks != null && record.remarks!.isNotEmpty) ...[
              _buildInfoRow('Remarks', record.remarks!),
              const SizedBox(height: 8),
            ],

            // Edit and Delete buttons
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _editRecord(record, index),
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () => _deleteRecord(index),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToInputPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CocoaYieldInput(selectedFarm: widget.selectedFarm),
      ),
    );

    if (result != null && result is yield_model.YieldRecord) {
      await _loadRecords();
    }
  }

  void _editRecord(yield_model.YieldRecord record, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CocoaYieldInput(record: record, selectedFarm: widget.selectedFarm),
      ),
    );

    if (result != null && result is yield_model.YieldRecord) {
      await _loadRecords();
    }
  }

  void _deleteRecord(int index) async {
    final record = records[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                if (record.recordId != null) {
                  await _yieldService.deleteYieldRecord(record.recordId!);
                }
                await _loadRecords();
                Navigator.pop(context);
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting record: $e')),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}