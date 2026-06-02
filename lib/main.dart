import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guia_turistica/data/datasources/local_data_source.dart';
import 'package:guia_turistica/data/repositories/place_repository_impl.dart';
import 'package:guia_turistica/domain/use_cases/get_places_use_case.dart';
import 'package:guia_turistica/presentation/viewmodels/home_viewmodel.dart';
import 'package:guia_turistica/presentation/viewmodels/map_viewmodel.dart';
import 'package:guia_turistica/views/splash/splash_screen.dart';
import 'package:guia_turistica/views/home/home_screen.dart';
import 'package:guia_turistica/views/map/map_screen.dart';
import 'package:guia_turistica/views/favorites/favorites_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:guia_turistica/data/adapters/place_adapter.dart';
import 'package:guia_turistica/data/models/place.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PlaceAdapter());
  await Hive.openBox<Place>('user_places');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localDataSource = LocalDataSource();
    final repository = PlaceRepositoryImpl(localDataSource: localDataSource);
    final getPlacesUseCase = GetPlacesByCityAndCategory(repository);

    return MultiProvider(
      providers: [
        Provider<PlaceRepositoryImpl>.value(value: repository),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(getPlacesUseCase: getPlacesUseCase),
        ),
        ChangeNotifierProvider(
          create: (_) => MapViewModel(repository: repository),
        ),
      ],
      child: MaterialApp(
        title: 'Guía Turística Colombia',
        theme: ThemeData(primarySwatch: Colors.green),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/map': (context) => const MapScreen(),
          '/favorites': (context) => const FavoritesScreen(),
        },
      ),
    );
  }
}
