import 'package:flutter/material.dart';
import 'package:guia_turistica/data/models/city.dart';
import 'package:guia_turistica/data/models/place.dart';
import 'package:guia_turistica/domain/use_cases/get_places_use_case.dart';

class HomeViewModel extends ChangeNotifier {
  final GetPlacesByCityAndCategory getPlacesUseCase;
  List<Place> _places = [];
  String _selectedCityId = 'bogota';
  String _selectedCategory = 'tourism';
  bool _isLoading = false;

  HomeViewModel({required this.getPlacesUseCase}) {
    loadPlaces();
  }

  List<Place> get places => _places;
  String get selectedCityId => _selectedCityId;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  void selectCity(String cityId) {
    if (_selectedCityId != cityId) {
      _selectedCityId = cityId;
      loadPlaces();
    }
  }

  void selectCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      loadPlaces();
    }
  }

  Future<void> loadPlaces() async {
    _isLoading = true;
    notifyListeners();
    _places = await getPlacesUseCase(_selectedCityId, _selectedCategory);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(String placeId) async {
    final index = _places.indexWhere((p) => p.id == placeId);
    if (index != -1) {
      _places[index].isFavorite = !_places[index].isFavorite;
      notifyListeners();
      final repository = getPlacesUseCase.repository;
      await repository.toggleFavorite(placeId);
    }
  }

  Future<List<City>> getCities() async {
    return await getPlacesUseCase.repository.getCities();
  }
}
