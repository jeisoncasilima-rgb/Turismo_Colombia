import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String id;
  final String name;
  final double centerLat;
  final double centerLng;

  const City({
    required this.id,
    required this.name,
    required this.centerLat,
    required this.centerLng,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      centerLat: (json['center_lat'] ?? 0.0).toDouble(),
      centerLng: (json['center_lng'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'center_lat': centerLat,
      'center_lng': centerLng,
    };
  }

  @override
  List<Object?> get props => [id, name];
}
