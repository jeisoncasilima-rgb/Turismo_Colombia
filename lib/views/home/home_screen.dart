import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guia_turistica/data/models/city.dart';
import 'package:guia_turistica/presentation/viewmodels/home_viewmodel.dart';
import 'package:guia_turistica/views/add_city/add_city_screen.dart';
import 'package:guia_turistica/views/add_place/add_place_screen.dart';
import 'package:guia_turistica/views/detail/place_detail_screen.dart';
import 'package:guia_turistica/views/home/widgets/category_selector.dart';
import 'package:guia_turistica/views/home/widgets/place_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _cityRefreshKey = 0;

  void refreshCities() {
    setState(() {
      _cityRefreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guía Turística Colombia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddCityScreen()),
              );
              if (result == true) refreshCities();
            },
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => Navigator.pushNamed(context, '/map'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
        ],
      ),
      body: Column(
        children: [
          CitySelector(vm: vm, refreshKey: _cityRefreshKey),
          CategorySelector(
            selectedCategory: vm.selectedCategory,
            onCategorySelected: vm.selectCategory,
          ),
          if (vm.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (vm.places.isEmpty)
            const Expanded(
              child: Center(child: Text('No hay lugares en esta categoría')),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => vm.loadPlaces(),
                child: ListView.builder(
                  itemCount: vm.places.length,
                  itemBuilder: (ctx, index) {
                    final place = vm.places[index];
                    return PlaceCard(
                      place: place,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaceDetailScreen(place: place),
                          ),
                        );
                        vm.loadPlaces();
                      },
                      onFavoriteToggle: () => vm.toggleFavorite(place.id),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPlaceScreen()),
          );
          if (result == true) vm.loadPlaces();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CitySelector extends StatelessWidget {
  final HomeViewModel vm;
  final int refreshKey;
  const CitySelector({super.key, required this.vm, required this.refreshKey});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<City>>(
      key: ValueKey(refreshKey),
      future: vm.getCities(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 50,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final cities = snapshot.data!;
        return Container(
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cities.length,
            itemBuilder: (ctx, i) {
              final city = cities[i];
              final isSelected = vm.selectedCityId == city.id;
              return GestureDetector(
                onTap: () => vm.selectCity(city.id),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    city.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
