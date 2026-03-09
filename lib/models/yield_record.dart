// models/yield_record.dart
class YieldRecord {
  final String? recordId;
  final String farmerId;
  final String farmId;
  final DateTime harvestDate;
  final String beanType; // 'wet' or 'dry'
  final String beanGrade; // 'A', 'B', or 'C'
  final double quantityKg;
  final double? salesRevenue;
  final String? remarks;
  final DateTime? createdAt;

  YieldRecord({
    this.recordId,
    required this.farmerId,
    required this.farmId,
    required this.harvestDate,
    required this.beanType,
    required this.beanGrade,
    required this.quantityKg,
    this.salesRevenue,
    this.remarks,
    this.createdAt,
  });

  // Convert to Map for Supabase
  Map<String, dynamic> toMap() {
    return {
      if (recordId != null) 'recordId': recordId,
      'farmerId': farmerId,
      'farmId': farmId,
      'harvestDate': harvestDate.toIso8601String(),
      'beanType': beanType,
      'beanGrade': beanGrade,
      'quantityKg': quantityKg,
      'salesRevenue': salesRevenue,
      'remarks': remarks,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Create from Supabase response
  factory YieldRecord.fromMap(Map<String, dynamic> map) {
    return YieldRecord(
      recordId: map['recordId'],
      farmerId: map['farmerId'],
      farmId: map['farmId'],
      harvestDate: DateTime.parse(map['harvestDate']),
      beanType: map['beanType'],
      beanGrade: map['beanGrade'],
      quantityKg: (map['quantityKg'] as num).toDouble(),
      salesRevenue: map['salesRevenue']?.toDouble(),
      remarks: map['remarks'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  // Helper method to convert to your old format for UI compatibility
  Map<String, String> toLegacyFormat() {
    return {
      'date': '${harvestDate.year}-${harvestDate.month.toString().padLeft(2, '0')}-${harvestDate.day.toString().padLeft(2, '0')}',
      'beanType': beanType == 'wet' ? 'Wet' : 'Dry',
      'grade': 'Grade $beanGrade',
      'salesRevenue': quantityKg.toStringAsFixed(2),
      'salesIncome': salesRevenue?.toStringAsFixed(2) ?? '0.00',
      'remarks': remarks ?? '',
    };
  }
}