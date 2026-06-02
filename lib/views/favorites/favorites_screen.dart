import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guia_turistica/presentation/viewmodels/home_viewmodel.dart';
import 'package:guia_turistica/views/home/widgets/place_card.dart';
import 'package:guia_turistica/views/detail/place_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeVm = Provider.of<HomeViewModel>(context);
    final favorites = homeVm.places.where((p) => p.isFavorite).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: favorites.isEmpty
          ? const Center(child: Text('No tienes favoritos aún'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (ctx, i) => PlaceCard(
                place: favorites[i],
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            PlaceDetailScreen(place: favorites[i]))),
                onFavoriteToggle: () => homeVm.toggleFavorite(favorites[i].id),
              ),
            ),
    );
  }
}
