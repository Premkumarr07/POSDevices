import 'package:cloud_firestore/cloud_firestore.dart';

class VenueModel {
  final String id;
  final String name;
  final String type; // 'restaurant', 'bar', 'cafe'
  final bool active;
  final String timezone;
  final DateTime createdAt;
  final DateTime updatedAt;

  VenueModel({
    required this.id,
    required this.name,
    required this.type,
    required this.active,
    required this.timezone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VenueModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VenueModel(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? 'restaurant',
      active: data['active'] ?? true,
      timezone: data['timezone'] ?? 'America/New_York',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'restaurant',
      active: json['active'] ?? true,
      timezone: json['timezone'] ?? 'America/New_York',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'active': active,
    'timezone': timezone,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'type': type,
    'active': active,
    'timezone': timezone,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  VenueModel copyWith({
    String? id,
    String? name,
    String? type,
    bool? active,
    String? timezone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VenueModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      active: active ?? this.active,
      timezone: timezone ?? this.timezone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
