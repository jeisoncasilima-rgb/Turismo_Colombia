import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guia_turistica/data/models/place.dart';
import 'package:guia_turistica/data/repositories/place_repository.dart';

class MapViewModel extends ChangeNotifier {
  final PlaceRepository repository;
  Set<Marker> _markers = {};
  LatLng? _initialPosition;
  bool _isLoading = false;

  MapViewModel({required this.repository}) {
    loadMarkersForCity('bogota');
  }

  Set<Marker> get markers => _markers;
  LatLng? get initialPosition => _initialPosition;
  bool get isLoading => _isLoading;

  Future<void> loadMarkersForCity(String cityId) async {
    _isLoading = true;
    notifyListeners();
    final allPlaces = await repository.getPlaces();
    final cityPlaces = allPlaces.where((p) => p.cityId == cityId).toList();
    _markers.clear();
    for (var place in cityPlaces) {
      _markers.add(
        Marker(
          markerId: MarkerId(place.id),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(title: place.name, snippet: place.category),
        ),
      );
    }
    if (cityPlaces.isNotEmpty) {
      _initialPosition =
          LatLng(cityPlaces.first.latitude, cityPlaces.first.longitude);
    }
    _isLoading = false;
    notifyListeners();
  }
}
