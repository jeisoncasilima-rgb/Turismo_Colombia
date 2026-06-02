import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guia_turistica/data/models/place.dart';
import 'package:guia_turistica/data/repositories/place_repository_impl.dart';
import 'package:guia_turistica/presentation/viewmodels/place_detail_viewmodel.dart';
import 'package:guia_turistica/views/add_place/add_place_screen.dart';
import 'package:guia_turistica/views/detail/gallery_widget.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<PlaceRepositoryImpl>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => PlaceDetailViewModel(repository, place),
      child: const _PlaceDetailBody(),
    );
  }
}

class _PlaceDetailBody extends StatelessWidget {
  const _PlaceDetailBody();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PlaceDetailViewModel>(context);
    final place = vm.place;

    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
        actions: [
          if (place.isUserCreated)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddPlaceScreen(existingPlace: place),
                  ),
                );
                if (!context.mounted) return;
                if (result == true) {
                  final exists = await vm.reload();
                  if (!exists) {
                    if (context.mounted) Navigator.pop(context);
                  }
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GalleryWidget(imageUrls: place.imageUrls),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(place.description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.green),
                      const SizedBox(width: 8),
                      Text('Lat: ${place.latitude}, Lng: ${place.longitude}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          place.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: vm.toggleFavorite,
                      ),
                      const SizedBox(width: 8),
                      Text(place.isFavorite
                          ? 'En favoritos'
                          : 'Agregar a favoritos'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
