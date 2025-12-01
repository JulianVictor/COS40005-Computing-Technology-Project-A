import 'dart:convert';

class FarmSelection {
  final String farmId;
  final String ownerId;
  final String farmName;
  final String state;
  final String district;
  final String village;
  final String postcode;
  final double areaHectares;
  final int treeCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final double? latitude;
  final double? longitude;

  FarmSelection({
    required this.farmId,
    required this.ownerId,
    required this.farmName,
    required this.state,
    required this.district,
    required this.village,
    required this.postcode,
    required this.areaHectares,
    required this.treeCount,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    this.latitude,
    this.longitude,
  });

  // Factory method that matches Supabase's lowercase column names
  factory FarmSelection.fromMap(Map<String, dynamic> map) {
    return FarmSelection(
      // Supabase returns lowercase keys: farmid, ownerid, farmname, etc.
      farmId: map['farmid']?.toString() ?? '',
      ownerId: map['ownerid']?.toString() ?? '',
      farmName: map['farmname']?.toString() ?? '',
      state: map['state']?.toString() ?? '',
      district: map['district']?.toString() ?? '',
      village: map['village']?.toString() ?? '',
      postcode: map['postcode']?.toString() ?? '',
      areaHectares: _parseDouble(map['areahectares']),
      treeCount: _parseInt(map['treecount']),
      createdAt: _parseDateTime(map['createdat']),
      updatedAt: _parseDateTime(map['updatedat']),
      isActive: map['isactive'] ?? true,
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      try {
        return double.tryParse(value) ?? 0.0;
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) {
      try {
        return int.tryParse(value) ?? 0;
      } catch (e) {
        return 0;
      }
    }
    return 0;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  // Map for Supabase insertion (using lowercase for Supabase)
  Map<String, dynamic> toSupabaseMap() {
    return {
      'ownerid': ownerId,
      'farmname': farmName,
      'state': state,
      'district': district,
      'village': village,
      'postcode': postcode,
      'areahectares': areaHectares,
      'treecount': treeCount,
      'isactive': isActive,
      'createdat': createdAt.toIso8601String(),
      'updatedat': updatedAt.toIso8601String(),
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  // Map for Flutter usage (PascalCase for consistency)
  Map<String, dynamic> toMap() {
    return {
      'farmId': farmId,
      'ownerId': ownerId,
      'farmName': farmName,
      'state': state,
      'district': district,
      'village': village,
      'postcode': postcode,
      'areaHectares': areaHectares,
      'treeCount': treeCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  // Copy with method for updates
  FarmSelection copyWith({
    String? farmId,
    String? ownerId,
    String? farmName,
    String? state,
    String? district,
    String? village,
    String? postcode,
    double? areaHectares,
    int? treeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    double? latitude,
    double? longitude,
  }) {
    return FarmSelection(
      farmId: farmId ?? this.farmId,
      ownerId: ownerId ?? this.ownerId,
      farmName: farmName ?? this.farmName,
      state: state ?? this.state,
      district: district ?? this.district,
      village: village ?? this.village,
      postcode: postcode ?? this.postcode,
      areaHectares: areaHectares ?? this.areaHectares,
      treeCount: treeCount ?? this.treeCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() {
    return 'FarmSelection(farmId: $farmId, farmName: $farmName, state: $state, district: $district)';
  }
}