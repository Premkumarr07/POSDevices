import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String venueId;
  final String name;
  final String? icon;
  final int order;
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.venueId,
    required this.name,
    this.icon,
    required this.order,
    required this.createdAt,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      venueId: data['venueId'] ?? '',
      name: data['name'] ?? '',
      icon: data['icon'],
      order: data['order'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      venueId: json['venueId'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'],
      order: json['order'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'venueId': venueId,
        'name': name,
        'icon': icon,
        'order': order,
        'createdAt': createdAt.toIso8601String(),
      };

  Map<String, dynamic> toFirestore() => {
        'venueId': venueId,
        'name': name,
        'icon': icon,
        'order': order,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  CategoryModel copyWith({
    String? id,
    String? venueId,
    String? name,
    String? icon,
    int? order,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      venueId: venueId ?? this.venueId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
