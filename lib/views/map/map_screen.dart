import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:guia_turistica/core/constants/app_constants.dart';
import 'package:guia_turistica/presentation/viewmodels/map_viewmodel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MapViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de lugares')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: vm.initialPosition ?? const LatLng(4.7110, -74.0721),
                zoom: 12,
              ),
              markers: vm.markers,
              onMapCreated: (controller) => _mapController = controller,
            ),
    );
  }
}
