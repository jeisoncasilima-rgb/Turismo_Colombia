import 'package:guia_turistica/data/models/place.dart';
import 'package:guia_turistica/data/repositories/place_repository.dart';

class GetPlacesByCityAndCategory {
  final PlaceRepository repository;

  GetPlacesByCityAndCategory(this.repository);

  Future<List<Place>> call(String cityId, String category) async {
    final allPlaces = await repository.getPlaces();
    return allPlaces
        .where((p) => p.cityId == cityId && p.category == category)
        .toList();
  }
}
