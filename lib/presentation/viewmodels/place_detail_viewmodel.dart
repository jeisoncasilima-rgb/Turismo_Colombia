import 'package:flutter/material.dart';
import 'package:guia_turistica/data/models/place.dart';
import 'package:guia_turistica/data/repositories/place_repository_impl.dart';

class PlaceDetailViewModel extends ChangeNotifier {
  final PlaceRepositoryImpl _repository;
  Place _place;

  PlaceDetailViewModel(this._repository, this._place);

  Place get place => _place;

  Future<void> toggleFavorite() async {
    await _repository.toggleFavorite(_place.id);
    // Actualizar el estado local después de cambiar en el repositorio
    final updatedPlaces = await _repository.getPlaces();
    final updated = updatedPlaces.firstWhere(
      (p) => p.id == _place.id,
      orElse: () =>
          _place, // si no lo encuentra, mantener el actual (no debería pasar)
    );
    _place = updated;
    notifyListeners();
  }

  /// Recarga los datos del lugar. Retorna `true` si el lugar aún existe,
  /// `false` si fue eliminado (para que la pantalla se cierre).
  Future<bool> reload() async {
    final updatedPlaces = await _repository.getPlaces();
    try {
      final updated = updatedPlaces.firstWhere((p) => p.id == _place.id);
      _place = updated;
      notifyListeners();
      return true;
    } catch (e) {
      // El lugar ya no existe (fue eliminado)
      return false;
    }
  }
}
