import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceModel {
  final String id;
  final String venueId;
  final String name;
  final String platform; // 'android', 'ios', 'web'
  final String status; // 'online', 'offline'
  final DateTime? lastSeenAt;
  final String appVersion;
  final int menuVersion;
  final DateTime createdAt;

  DeviceModel({
    required this.id,
    required this.venueId,
    required this.name,
    required this.platform,
    required this.status,
    this.lastSeenAt,
    required this.appVersion,
    required this.menuVersion,
    required this.createdAt,
  });

  factory DeviceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DeviceModel(
      id: doc.id,
      venueId: data['venueId'] ?? '',
      name: data['name'] ?? '',
      platform: data['platform'] ?? 'android',
      status: data['status'] ?? 'offline',
      lastSeenAt: (data['lastSeenAt'] as Timestamp?)?.toDate(),
      appVersion: data['appVersion'] ?? '1.0.0',
      menuVersion: data['menuVersion'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] ?? '',
      venueId: json['venueId'] ?? '',
      name: json['name'] ?? '',
      platform: json['platform'] ?? 'android',
      status: json['status'] ?? 'offline',
      lastSeenAt: json['lastSeenAt'] != null
          ? DateTime.parse(json['lastSeenAt'])
          : null,
      appVersion: json['appVersion'] ?? '1.0.0',
      menuVersion: json['menuVersion'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'venueId': venueId,
        'name': name,
        'platform': platform,
        'status': status,
        'lastSeenAt': lastSeenAt?.toIso8601String(),
        'appVersion': appVersion,
        'menuVersion': menuVersion,
        'createdAt': createdAt.toIso8601String(),
      };

  Map<String, dynamic> toFirestore() => {
        'venueId': venueId,
        'name': name,
        'platform': platform,
        'status': status,
        'lastSeenAt': lastSeenAt != null ? Timestamp.fromDate(lastSeenAt!) : null,
        'appVersion': appVersion,
        'menuVersion': menuVersion,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  DeviceModel copyWith({
    String? id,
    String? venueId,
    String? name,
    String? platform,
    String? status,
    DateTime? lastSeenAt,
    String? appVersion,
    int? menuVersion,
    DateTime? createdAt,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      venueId: venueId ?? this.venueId,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      status: status ?? this.status,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      appVersion: appVersion ?? this.appVersion,
      menuVersion: menuVersion ?? this.menuVersion,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
