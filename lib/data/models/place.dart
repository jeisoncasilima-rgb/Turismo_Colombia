import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final String id;
  final String name;
  final String description;
  final String cityId;
  final String category; // 'food', 'tourism', 'culture'
  final double latitude;
  final double longitude;
  final List<String> imageUrls;
  bool isFavorite;
  final bool isUserCreated;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.cityId,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.imageUrls,
    this.isFavorite = false,
    this.isUserCreated = false,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      cityId: json['city_id'],
      category: json['category'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      isFavorite: json['is_favorite'] ?? false,
      isUserCreated: json['is_user_created'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'city_id': cityId,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'image_urls': imageUrls,
      'is_favorite': isFavorite,
      'is_user_created': isUserCreated,
    };
  }

  Place copyWith({
    String? name,
    String? description,
    String? cityId,
    String? category,
    double? latitude,
    double? longitude,
    List<String>? imageUrls,
    bool? isFavorite,
  }) {
    return Place(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      cityId: cityId ?? this.cityId,
      category: category ?? this.category,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrls: imageUrls ?? this.imageUrls,
      isFavorite: isFavorite ?? this.isFavorite,
      isUserCreated: isUserCreated,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, cityId, category, isFavorite, isUserCreated];
}
