import 'dart:convert';

// User Model
class AppUser {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String role;
  final String accountStatus;
  final List<String> farms;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;

  AppUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.accountStatus,
    required this.farms,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      userId: map['userId'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String?,
      role: map['role'] as String,
      accountStatus: map['accountStatus'] as String,
      farms: List<String>.from(map['farms'] ?? []),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      lastLoginAt: map['lastLoginAt'] != null 
          ? DateTime.parse(map['lastLoginAt'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'accountStatus': accountStatus,
      'farms': farms,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }
}

// Farm Model
class Farm {
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

  Farm({
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
  });

  factory Farm.fromMap(Map<String, dynamic> map) {
    return Farm(
      farmId: map['farmId'] as String,
      ownerId: map['ownerId'] as String,
      farmName: map['farmName'] as String,
      state: map['state'] as String,
      district: map['district'] as String,
      village: map['village'] as String,
      postcode: map['postcode'] as String,
      areaHectares: (map['areaHectares'] as num).toDouble(),
      treeCount: map['treeCount'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      isActive: map['isActive'] as bool,
    );
  }

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
    };
  }
}

// Scan Model
class Scan {
  final String scanId;
  final String farmerId;
  final String farmId;
  final String imageUrl;
  final String imagePath;
  final int eggsDetected;
  final double confidenceScore;
  final DateTime scanDate;
  final GpsLocation? gpsLocation;

  Scan({
    required this.scanId,
    required this.farmerId,
    required this.farmId,
    required this.imageUrl,
    required this.imagePath,
    required this.eggsDetected,
    required this.confidenceScore,
    required this.scanDate,
    this.gpsLocation,
  });

  factory Scan.fromMap(Map<String, dynamic> map) {
    return Scan(
      scanId: map['scanId'] as String,
      farmerId: map['farmerId'] as String,
      farmId: map['farmId'] as String,
      imageUrl: map['imageUrl'] as String,
      imagePath: map['imagePath'] as String,
      eggsDetected: map['eggsDetected'] as int,
      confidenceScore: (map['confidenceScore'] as num).toDouble(),
      scanDate: DateTime.parse(map['scanDate'] as String),
      gpsLocation: map['gpsLocation'] != null 
          ? GpsLocation.fromMap(map['gpsLocation'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'scanId': scanId,
      'farmerId': farmerId,
      'farmId': farmId,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'eggsDetected': eggsDetected,
      'confidenceScore': confidenceScore,
      'scanDate': scanDate.toIso8601String(),
      'gpsLocation': gpsLocation?.toMap(),
    };
  }
}

class GpsLocation {
  final double lat;
  final double lng;

  GpsLocation({required this.lat, required this.lng});

  factory GpsLocation.fromMap(Map<String, dynamic> map) {
    return GpsLocation(
      lat: (map['lat'] as num).toDouble(),
      lng: (map['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

// Scan Session Model
class ScanSession {
  final String sessionId;
  final String farmerId;
  final String farmId;
  final List<String> samples;
  final int totalEggs;
  final double averageEggs;
  final int cumulativeEggs;
  final String finalDecision;
  final String? recommendationReason;
  final DateTime sessionDate;
  final bool completed;

  ScanSession({
    required this.sessionId,
    required this.farmerId,
    required this.farmId,
    required this.samples,
    required this.totalEggs,
    required this.averageEggs,
    required this.cumulativeEggs,
    required this.finalDecision,
    this.recommendationReason,
    required this.sessionDate,
    required this.completed,
  });

  factory ScanSession.fromMap(Map<String, dynamic> map) {
    return ScanSession(
      sessionId: map['sessionId'] as String,
      farmerId: map['farmerId'] as String,
      farmId: map['farmId'] as String,
      samples: List<String>.from(map['samples'] ?? []),
      totalEggs: map['totalEggs'] as int,
      averageEggs: (map['averageEggs'] as num).toDouble(),
      cumulativeEggs: map['cumulativeEggs'] as int,
      finalDecision: map['finalDecision'] as String,
      recommendationReason: map['recommendationReason'] as String?,
      sessionDate: DateTime.parse(map['sessionDate'] as String),
      completed: map['completed'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'farmerId': farmerId,
      'farmId': farmId,
      'samples': samples,
      'totalEggs': totalEggs,
      'averageEggs': averageEggs,
      'cumulativeEggs': cumulativeEggs,
      'finalDecision': finalDecision,
      'recommendationReason': recommendationReason,
      'sessionDate': sessionDate.toIso8601String(),
      'completed': completed,
    };
  }
}

// Economic Settings Model
class EconomicSettings {
  final String settingId;
  final double pesticideCostPerLiter;
  final double workCostPerDay;
  final double wetCocoaBeanPricePerKg;
  final double expectedYieldPerHectare;
  final double sprayThreshold;
  final double monitorThreshold;
  final DateTime effectiveFrom;
  final DateTime effectiveTo;
  final bool isActive;
  final String createdBy;
  final DateTime createdAt;

  EconomicSettings({
    required this.settingId,
    required this.pesticideCostPerLiter,
    required this.workCostPerDay,
    required this.wetCocoaBeanPricePerKg,
    required this.expectedYieldPerHectare,
    required this.sprayThreshold,
    required this.monitorThreshold,
    required this.effectiveFrom,
    required this.effectiveTo,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
  });

  factory EconomicSettings.fromMap(Map<String, dynamic> map) {
    return EconomicSettings(
      settingId: map['settingId'] as String,
      pesticideCostPerLiter: (map['pesticideCostPerLiter'] as num).toDouble(),
      workCostPerDay: (map['workCostPerDay'] as num).toDouble(),
      wetCocoaBeanPricePerKg: (map['wetCocoaBeanPricePerKg'] as num).toDouble(),
      expectedYieldPerHectare: (map['expectedYieldPerHectare'] as num).toDouble(),
      sprayThreshold: (map['sprayThreshold'] as num).toDouble(),
      monitorThreshold: (map['monitorThreshold'] as num).toDouble(),
      effectiveFrom: DateTime.parse(map['effectiveFrom'] as String),
      effectiveTo: DateTime.parse(map['effectiveTo'] as String),
      isActive: map['isActive'] as bool,
      createdBy: map['createdBy'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'settingId': settingId,
      'pesticideCostPerLiter': pesticideCostPerLiter,
      'workCostPerDay': workCostPerDay,
      'wetCocoaBeanPricePerKg': wetCocoaBeanPricePerKg,
      'expectedYieldPerHectare': expectedYieldPerHectare,
      'sprayThreshold': sprayThreshold,
      'monitorThreshold': monitorThreshold,
      'effectiveFrom': effectiveFrom.toIso8601String(),
      'effectiveTo': effectiveTo.toIso8601String(),
      'isActive': isActive,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// Pesticide Costs Model
class PesticideCost {
  final String costId;
  final String farmerId;
  final String farmId;
  final String pesticideBrand;
  final double pesticidePrice;
  final int numSprayPump;
  final double pesticideRate;
  final double pesticideCost;
  final DateTime createdAt;

  PesticideCost({
    required this.costId,
    required this.farmerId,
    required this.farmId,
    required this.pesticideBrand,
    required this.pesticidePrice,
    required this.numSprayPump,
    required this.pesticideRate,
    required this.pesticideCost,
    required this.createdAt,
  });

  factory PesticideCost.fromMap(Map<String, dynamic> map) {
    return PesticideCost(
      costId: map['costId'] as String,
      farmerId: map['farmerId'] as String,
      farmId: map['farmId'] as String,
      pesticideBrand: map['pesticideBrand'] as String,
      pesticidePrice: (map['pesticidePrice'] as num).toDouble(),
      numSprayPump: map['numSprayPump'] as int,
      pesticideRate: (map['pesticideRate'] as num).toDouble(),
      pesticideCost: (map['pesticideCost'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'costId': costId,
      'farmerId': farmerId,
      'farmId': farmId,
      'pesticideBrand': pesticideBrand,
      'pesticidePrice': pesticidePrice,
      'numSprayPump': numSprayPump,
      'pesticideRate': pesticideRate,
      'pesticideCost': pesticideCost,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// Labour Costs Model
class LabourCost {
  final String labourId;
  final String farmerId;
  final String farmId;
  final double dailyLabourCost;
  final double farmAreaSprayPerDay;
  final double workCostPerDay;
  final double wetCocoaBeanPricePerKg;
  final int pesticideFrequencyPerYear;
  final double expectedYieldPerHectare;
  final DateTime createdAt;

  LabourCost({
    required this.labourId,
    required this.farmerId,
    required this.farmId,
    required this.dailyLabourCost,
    required this.farmAreaSprayPerDay,
    required this.workCostPerDay,
    required this.wetCocoaBeanPricePerKg,
    required this.pesticideFrequencyPerYear,
    required this.expectedYieldPerHectare,
    required this.createdAt,
  });

  factory LabourCost.fromMap(Map<String, dynamic> map) {
    return LabourCost(
      labourId: map['labourId'] as String,
      farmerId: map['farmerId'] as String,
      farmId: map['farmId'] as String,
      dailyLabourCost: (map['dailyLabourCost'] as num).toDouble(),
      farmAreaSprayPerDay: (map['farmAreaSprayPerDay'] as num).toDouble(),
      workCostPerDay: (map['workCostPerDay'] as num).toDouble(),
      wetCocoaBeanPricePerKg: (map['wetCocoaBeanPricePerKg'] as num).toDouble(),
      pesticideFrequencyPerYear: map['pesticideFrequencyPerYear'] as int,
      expectedYieldPerHectare: (map['expectedYieldPerHectare'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'labourId': labourId,
      'farmerId': farmerId,
      'farmId': farmId,
      'dailyLabourCost': dailyLabourCost,
      'farmAreaSprayPerDay': farmAreaSprayPerDay,
      'workCostPerDay': workCostPerDay,
      'wetCocoaBeanPricePerKg': wetCocoaBeanPricePerKg,
      'pesticideFrequencyPerYear': pesticideFrequencyPerYear,
      'expectedYieldPerHectare': expectedYieldPerHectare,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// Scan Report Model
class ScanReport {
  final String reportId;
  final String sessionId;
  final String farmerId;
  final String farmId;
  final String? pesticideType;
  final double? pesticideCost;
  final double? pesticidePrice;
  final double? pesticideRate;
  final double? dailyLabourCost;
  final double? farmAreaSprayPerDay;
  final double? wetCocoaBeanPricePerKg;
  final int? pesticideFrequencyPerYear;
  final double? expectedYieldPerHectare;
  final int? totalSample;
  final int? cumulativeEggs;
  final String? finalDecision;
  final DateTime createdAt;

  ScanReport({
    required this.reportId,
    required this.sessionId,
    required this.farmerId,
    required this.farmId,
    this.pesticideType,
    this.pesticideCost,
    this.pesticidePrice,
    this.pesticideRate,
    this.dailyLabourCost,
    this.farmAreaSprayPerDay,
    this.wetCocoaBeanPricePerKg,
    this.pesticideFrequencyPerYear,
    this.expectedYieldPerHectare,
    this.totalSample,
    this.cumulativeEggs,
    this.finalDecision,
    required this.createdAt,
  });

  factory ScanReport.fromMap(Map<String, dynamic> map) {
    return ScanReport(
      reportId: map['reportId'] as String,
      sessionId: map['sessionId'] as String,
      farmerId: map['farmerId'] as String,
      farmId: map['farmId'] as String,
      pesticideType: map['pesticideType'] as String?,
      pesticideCost: map['pesticideCost'] != null ? (map['pesticideCost'] as num).toDouble() : null,
      pesticidePrice: map['pesticidePrice'] != null ? (map['pesticidePrice'] as num).toDouble() : null,
      pesticideRate: map['pesticideRate'] != null ? (map['pesticideRate'] as num).toDouble() : null,
      dailyLabourCost: map['dailyLabourCost'] != null ? (map['dailyLabourCost'] as num).toDouble() : null,
      farmAreaSprayPerDay: map['farmAreaSprayPerDay'] != null ? (map['farmAreaSprayPerDay'] as num).toDouble() : null,
      wetCocoaBeanPricePerKg: map['wetCocoaBeanPricePerKg'] != null ? (map['wetCocoaBeanPricePerKg'] as num).toDouble() : null,
      pesticideFrequencyPerYear: map['pesticideFrequencyPerYear'] as int?,
      expectedYieldPerHectare: map['expectedYieldPerHectare'] != null ? (map['expectedYieldPerHectare'] as num).toDouble() : null,
      totalSample: map['totalSample'] as int?,
      cumulativeEggs: map['cumulativeEggs'] as int?,
      finalDecision: map['finalDecision'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reportId': reportId,
      'sessionId': sessionId,
      'farmerId': farmerId,
      'farmId': farmId,
      'pesticideType': pesticideType,
      'pesticideCost': pesticideCost,
      'pesticidePrice': pesticidePrice,
      'pesticideRate': pesticideRate,
      'dailyLabourCost': dailyLabourCost,
      'farmAreaSprayPerDay': farmAreaSprayPerDay,
      'wetCocoaBeanPricePerKg': wetCocoaBeanPricePerKg,
      'pesticideFrequencyPerYear': pesticideFrequencyPerYear,
      'expectedYieldPerHectare': expectedYieldPerHectare,
      'totalSample': totalSample,
      'cumulativeEggs': cumulativeEggs,
      'finalDecision': finalDecision,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// Yield Record Model
class YieldRecord {
  final String recordId;
  final String farmerId;
  final String farmId;
  final DateTime harvestDate;
  final String beanType;
  final String beanGrade;
  final double quantityKg;
  final double? salesRevenue;
  final String? remarks;
  final DateTime createdAt;

  YieldRecord({
    required this.recordId,
    required this.farmerId,
    required this.farmId,
    required this.harvestDate,
    required this.beanType,
    required this.beanGrade,
    required this.quantityKg,
    this.salesRevenue,
    this.remarks,
    required this.createdAt,
  });

  factory YieldRecord.fromMap(Map<String, dynamic> map) {
    return YieldRecord(
      recordId: map['recordId'] as String,
      farmerId: map['farmerId'] as String,
      farmId: map['farmId'] as String,
      harvestDate: DateTime.parse(map['harvestDate'] as String),
      beanType: map['beanType'] as String,
      beanGrade: map['beanGrade'] as String,
      quantityKg: (map['quantityKg'] as num).toDouble(),
      salesRevenue: map['salesRevenue'] != null ? (map['salesRevenue'] as num).toDouble() : null,
      remarks: map['remarks'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recordId': recordId,
      'farmerId': farmerId,
      'farmId': farmId,
      'harvestDate': harvestDate.toIso8601String(),
      'beanType': beanType,
      'beanGrade': beanGrade,
      'quantityKg': quantityKg,
      'salesRevenue': salesRevenue,
      'remarks': remarks,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// System Metrics Model
class SystemMetrics {
  final String metricId;
  final DateTime date;
  final int totalUsers;
  final int activeUsers;
  final int totalScans;
  final Map<String, dynamic>? scansByRegion;
  final Map<String, dynamic>? decisions;
  final double? averageConfidence;
  final int? falsePositives;
  final int? falseNegatives;
  final DateTime createdAt;

  SystemMetrics({
    required this.metricId,
    required this.date,
    required this.totalUsers,
    required this.activeUsers,
    required this.totalScans,
    this.scansByRegion,
    this.decisions,
    this.averageConfidence,
    this.falsePositives,
    this.falseNegatives,
    required this.createdAt,
  });

  factory SystemMetrics.fromMap(Map<String, dynamic> map) {
    return SystemMetrics(
      metricId: map['metricId'] as String,
      date: DateTime.parse(map['date'] as String),
      totalUsers: map['totalUsers'] as int,
      activeUsers: map['activeUsers'] as int,
      totalScans: map['totalScans'] as int,
      scansByRegion: map['scansByRegion'] != null 
          ? Map<String, dynamic>.from(map['scansByRegion'] as Map)
          : null,
      decisions: map['decisions'] != null 
          ? Map<String, dynamic>.from(map['decisions'] as Map)
          : null,
      averageConfidence: map['averageConfidence'] != null 
          ? (map['averageConfidence'] as num).toDouble() 
          : null,
      falsePositives: map['falsePositives'] as int?,
      falseNegatives: map['falseNegatives'] as int?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'metricId': metricId,
      'date': date.toIso8601String(),
      'totalUsers': totalUsers,
      'activeUsers': activeUsers,
      'totalScans': totalScans,
      'scansByRegion': scansByRegion,
      'decisions': decisions,
      'averageConfidence': averageConfidence,
      'falsePositives': falsePositives,
      'falseNegatives': falseNegatives,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}