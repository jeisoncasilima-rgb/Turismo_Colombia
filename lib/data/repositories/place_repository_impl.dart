import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:guia_turistica/data/datasources/local_data_source.dart';
import 'package:guia_turistica/data/models/city.dart';
import 'package:guia_turistica/data/models/place.dart';
import 'package:guia_turistica/data/repositories/place_repository.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final LocalDataSource localDataSource;
  late Box<Place> _userPlacesBox;
  List<Place> _cachedPlaces = [];
  List<City> _cachedCities = [];
  bool _isInitialized = false;
  final Completer<void> _initCompleter = Completer();
  final _favoritesController = StreamController<List<Place>>.broadcast();

  PlaceRepositoryImpl({required this.localDataSource}) {
    _initialize();
  }

  Future<void> _initialize() async {
    _userPlacesBox = await Hive.openBox<Place>('user_places');
    final staticPlaces = await localDataSource.getStaticPlaces();
    final userPlaces = _userPlacesBox.values.toList();
    _cachedPlaces = [...staticPlaces, ...userPlaces];

    // Cargar ciudades: estáticas + de usuario
    final staticCities = await localDataSource.getStaticCities();
    final userCities = await localDataSource.getUserCities();
    _cachedCities = [...staticCities, ...userCities];

    _isInitialized = true;
    _initCompleter.complete();
    _emitFavorites();
  }

  void _emitFavorites() {
    final favorites = _cachedPlaces.where((p) => p.isFavorite).toList();
    _favoritesController.add(favorites);
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) await _initCompleter.future;
  }

  @override
  Future<List<City>> getCities() async {
    await _ensureInitialized();
    return _cachedCities;
  }

  @override
  Future<List<Place>> getPlaces() async {
    await _ensureInitialized();
    return _cachedPlaces;
  }

  @override
  Future<void> toggleFavorite(String placeId) async {
    await _ensureInitialized();
    final index = _cachedPlaces.indexWhere((p) => p.id == placeId);
    if (index != -1) {
      _cachedPlaces[index].isFavorite = !_cachedPlaces[index].isFavorite;
      final place = _cachedPlaces[index];
      if (place.isUserCreated) {
        await _userPlacesBox.put(place.id, place);
      }
      // Guardar favoritos en SharedPreferences
      await localDataSource.saveFavorites(_cachedPlaces);
      _emitFavorites();
    }
  }

  @override
  Stream<List<Place>> watchFavorites() => _favoritesController.stream;

  Future<void> addPlace(Place place) async {
    await _ensureInitialized();
    await _userPlacesBox.put(place.id, place);
    _cachedPlaces.add(place);
    _emitFavorites();
  }

  Future<void> updateUserPlace(Place updatedPlace) async {
    await _ensureInitialized();
    final index = _cachedPlaces.indexWhere((p) => p.id == updatedPlace.id);
    if (index != -1 && _cachedPlaces[index].isUserCreated) {
      _cachedPlaces[index] = updatedPlace;
      await _userPlacesBox.put(updatedPlace.id, updatedPlace);
      _emitFavorites();
    }
  }

  Future<void> deletePlace(String placeId) async {
    await _ensureInitialized();
    final place = _cachedPlaces.firstWhere((p) => p.id == placeId);
    if (place.isUserCreated) {
      await _userPlacesBox.delete(placeId);
      _cachedPlaces.removeWhere((p) => p.id == placeId);
      _emitFavorites();
    }
  }

  Future<void> addCity(City city) async {
    await _ensureInitialized();
    await localDataSource.saveUserCity(city);
    _cachedCities.add(city);
  }

  void dispose() {
    _favoritesController.close();
    _userPlacesBox.close();
  }
}
