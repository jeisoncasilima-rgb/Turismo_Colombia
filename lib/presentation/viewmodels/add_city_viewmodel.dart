import 'package:flutter/material.dart';
import 'package:guia_turistica/data/models/city.dart';
import 'package:guia_turistica/data/repositories/place_repository_impl.dart';
import 'package:uuid/uuid.dart';

class AddCityViewModel extends ChangeNotifier {
  final PlaceRepositoryImpl _repository;
  final nameController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AddCityViewModel(this._repository);

  Future<bool> saveCity() async {
    final name = nameController.text.trim();
    if (name.isEmpty) return false;

    _isLoading = true;
    notifyListeners();

    final newCity = City(
      id: const Uuid().v4(),
      name: name,
      centerLat: double.tryParse(latController.text) ?? 0.0,
      centerLng: double.tryParse(lngController.text) ?? 0.0,
    );

    await _repository.addCity(newCity);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    latController.dispose();
    lngController.dispose();
    super.dispose();
  }
}
