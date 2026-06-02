import 'package:hive/hive.dart';
import 'package:guia_turistica/data/models/place.dart';

@HiveType(typeId: 0)
class PlaceAdapter extends TypeAdapter<Place> {
  @override
  final int typeId = 0;

  @override
  Place read(BinaryReader reader) {
    return Place(
      id: reader.readString(),
      name: reader.readString(),
      description: reader.readString(),
      cityId: reader.readString(),
      category: reader.readString(),
      latitude: reader.readDouble(),
      longitude: reader.readDouble(),
      imageUrls: reader.readList().cast<String>(),
      isFavorite: reader.readBool(),
      isUserCreated: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Place obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.description);
    writer.writeString(obj.cityId);
    writer.writeString(obj.category);
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longitude);
    writer.writeList(obj.imageUrls);
    writer.writeBool(obj.isFavorite);
    writer.writeBool(obj.isUserCreated);
  }
}
