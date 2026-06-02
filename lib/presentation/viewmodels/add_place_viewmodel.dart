import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guia_turistica/data/models/city.dart';
import 'package:guia_turistica/data/models/place.dart';
import 'package:guia_turistica/data/repositories/place_repository_impl.dart';
import 'package:guia_turistica/services/image_picker_service.dart';
import 'package:uuid/uuid.dart';

class AddPlaceViewModel extends ChangeNotifier {
  final PlaceRepositoryImpl _repository;
  final ImagePickerService _imageService = ImagePickerService();

  // Controladores de texto
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  List<City> _cities = [];
  String? _selectedCityId;
  String _category = 'tourism';
  List<String> imagePaths = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final bool isEditing;
  final String? _existingPlaceId;

  // Getters
  List<City> get cities => _cities;
  String? get selectedCityId => _selectedCityId;
  String get category => _category;

  AddPlaceViewModel(this._repository, {Place? existingPlace})
      : isEditing = existingPlace != null,
        _existingPlaceId = existingPlace?.id {
    _loadCities();
    if (existingPlace != null) {
      nameController.text = existingPlace.name;
      descriptionController.text = existingPlace.description;
      _selectedCityId = existingPlace.cityId;
      _category = existingPlace.category;
      latitudeController.text = existingPlace.latitude.toString();
      longitudeController.text = existingPlace.longitude.toString();
      imagePaths = List.from(existingPlace.imageUrls);
    }
  }

  Future<void> _loadCities() async {
    _cities = await _repository.getCities();
    notifyListeners();
  }

  Future<List<City>> getCitiesFuture() async {
    if (_cities.isEmpty) await _loadCities();
    return _cities;
  }

  void setCity(String? cityId) {
    _selectedCityId = cityId;
    notifyListeners();
  }

  void setCategory(String newCategory) {
    _category = newCategory;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final path = await _imageService.pickImageFromCamera();
    if (path != null) {
      imagePaths.clear();
      imagePaths.add(path);
      notifyListeners();
    }
  }

  Future<bool> savePlace() async {
    if (nameController.text.trim().isEmpty) return false;
    if (descriptionController.text.trim().isEmpty) return false;
    if (_selectedCityId == null || _selectedCityId!.isEmpty) return false;
    if (!isEditing && imagePaths.isEmpty) return false;

    _isLoading = true;
    notifyListeners();

    final lat = double.tryParse(latitudeController.text) ?? 0.0;
    final lng = double.tryParse(longitudeController.text) ?? 0.0;

    if (isEditing) {
      final updatedPlace = Place(
        id: _existingPlaceId!,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        cityId: _selectedCityId!,
        category: _category,
        latitude: lat,
        longitude: lng,
        imageUrls: imagePaths,
        isFavorite: false,
        isUserCreated: true,
      );
      await _repository.updateUserPlace(updatedPlace);
    } else {
      final newPlace = Place(
        id: const Uuid().v4(),
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        cityId: _selectedCityId!,
        category: _category,
        latitude: lat,
        longitude: lng,
        imageUrls: imagePaths,
        isFavorite: false,
        isUserCreated: true,
      );
      await _repository.addPlace(newPlace);
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> deletePlace() async {
    if (_existingPlaceId != null) {
      await _repository.deletePlace(_existingPlaceId!);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }
}
