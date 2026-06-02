import 'dart:convert';
import 'package:guia_turistica/core/utils/asset_loader.dart';
import 'package:guia_turistica/data/models/city.dart';
import 'package:guia_turistica/data/models/place.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  // ==================== CIUDADES ESTÁTICAS (desde JSON) ====================
  Future<List<City>> getStaticCities() async {
    final jsonString =
        await AssetLoader.loadJsonAsset('assets/data/places.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final List<dynamic> citiesJson = data['cities'];
    return citiesJson.map((json) => City.fromJson(json)).toList();
  }

  // ==================== LUGARES ESTÁTICOS (desde JSON) ====================
  Future<List<Place>> getStaticPlaces() async {
    final jsonString =
        await AssetLoader.loadJsonAsset('assets/data/places.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final List<dynamic> placesJson = data['places'];
    var places = placesJson.map((json) => Place.fromJson(json)).toList();
    // Cargar favoritos guardados
    final favoriteIds = await _loadFavoriteIds();
    for (var place in places) {
      if (favoriteIds.contains(place.id)) place.isFavorite = true;
    }
    return places;
  }

  // ==================== FAVORITOS ====================
  Future<Set<String>> _loadFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('favorites') ?? [];
    return Set<String>.from(list);
  }

  Future<void> saveFavorites(List<Place> allPlaces) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = allPlaces.where((p) => p.isFavorite).map((p) => p.id).toList();
    await prefs.setStringList('favorites', ids);
  }

  // ==================== CIUDADES CREADAS POR USUARIO ====================
  // Usaremos SharedPreferences para guardar las ciudades adicionales (por simplicidad)
  // Formato: lista de mapas con id, name, center_lat, center_lng
  Future<List<City>> getUserCities() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('user_cities');
    if (jsonString == null) return [];
    final List<dynamic> list = json.decode(jsonString);
    return list.map((json) => City.fromJson(json)).toList();
  }

  Future<void> saveUserCity(City city) async {
    final prefs = await SharedPreferences.getInstance();
    final List<City> current = await getUserCities();
    current.add(city);
    final List<Map<String, dynamic>> jsonList =
        current.map((c) => c.toJson()).toList();
    await prefs.setString('user_cities', json.encode(jsonList));
  }
}
