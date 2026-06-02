import 'package:guia_turistica/data/models/city.dart';
import 'package:guia_turistica/data/models/place.dart';

abstract class PlaceRepository {
  Future<List<City>> getCities();
  Future<List<Place>> getPlaces();
  Future<void> toggleFavorite(String placeId);
  Stream<List<Place>> watchFavorites(); // opcional
}
