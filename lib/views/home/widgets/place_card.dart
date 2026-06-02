import 'package:flutter/material.dart';
import 'package:guia_turistica/data/models/place.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const PlaceCard(
      {super.key,
      required this.place,
      required this.onTap,
      required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: place.imageUrls.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(place.imageUrls.first,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(Icons.broken_image)),
              )
            : const Icon(Icons.place),
        title: Text(place.name),
        subtitle: Text(place.description.length > 80
            ? '${place.description.substring(0, 80)}...'
            : place.description),
        trailing: IconButton(
          icon: Icon(place.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red),
          onPressed: onFavoriteToggle,
        ),
        onTap: onTap,
      ),
    );
  }
}
