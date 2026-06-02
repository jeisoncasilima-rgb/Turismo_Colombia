import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guia_turistica/data/models/city.dart';
import 'package:guia_turistica/data/models/place.dart';
import 'package:guia_turistica/data/repositories/place_repository_impl.dart';
import 'package:guia_turistica/presentation/viewmodels/add_place_viewmodel.dart';

class AddPlaceScreen extends StatelessWidget {
  final Place? existingPlace;
  const AddPlaceScreen({super.key, this.existingPlace});

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<PlaceRepositoryImpl>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => AddPlaceViewModel(repository,
          existingPlace: existingPlace), // <- sin llaves
      child: const _AddPlaceForm(),
    );
  }
}

class _AddPlaceForm extends StatefulWidget {
  const _AddPlaceForm();

  @override
  State<_AddPlaceForm> createState() => _AddPlaceFormState();
}

class _AddPlaceFormState extends State<_AddPlaceForm> {
  @override
  Widget build(BuildContext context) {
    final vm =
        Provider.of<AddPlaceViewModel>(context); // <- ahora sí lo encuentra
    return Scaffold(
      appBar: AppBar(
        title: Text(vm.isEditing ? 'Editar lugar' : 'Agregar lugar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nombre *'),
              controller: vm.nameController,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Descripción *'),
              maxLines: 3,
              controller: vm.descriptionController,
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<City>>(
              future: vm.getCitiesFuture(),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 60,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final cities = snapshot.data!;
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Ciudad *'),
                  value: vm.selectedCityId,
                  hint: const Text('Selecciona una ciudad'),
                  items: cities.map((city) {
                    return DropdownMenuItem<String>(
                      value: city.id,
                      child: Text(city.name),
                    );
                  }).toList(),
                  onChanged: (value) => vm.setCity(value),
                );
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Categoría *'),
              value: vm.category,
              items: const [
                DropdownMenuItem(value: 'tourism', child: Text('Turismo')),
                DropdownMenuItem(value: 'food', child: Text('Comida')),
                DropdownMenuItem(value: 'culture', child: Text('Cultura')),
              ],
              onChanged: (value) => vm.setCategory(value!),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Latitud (opcional)',
                      helperText: 'Ej: 4.6052',
                    ),
                    keyboardType: TextInputType.number,
                    controller: vm.latitudeController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Longitud (opcional)',
                      helperText: 'Ej: -74.0554',
                    ),
                    keyboardType: TextInputType.number,
                    controller: vm.longitudeController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: vm.pickImage,
              icon: const Icon(Icons.camera_alt),
              label: Text(
                  vm.isEditing ? 'Cambiar foto' : 'Tomar foto (obligatorio)'),
            ),
            const SizedBox(height: 12),
            if (vm.imagePaths.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: vm.imagePaths.length,
                  itemBuilder: (ctx, i) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(vm.imagePaths[i]),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: vm.isLoading
                  ? null
                  : () async {
                      final success = await vm.savePlace();
                      if (success && context.mounted) {
                        Navigator.pop(context, true);
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Completa todos los campos obligatorios')),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14)),
              child: vm.isLoading
                  ? const CircularProgressIndicator()
                  : Text(vm.isEditing ? 'Actualizar lugar' : 'Guardar lugar'),
            ),
            if (vm.isEditing)
              TextButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Eliminar lugar'),
                      content: const Text(
                          '¿Estás seguro de que deseas eliminar este lugar?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancelar')),
                        TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Eliminar')),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await vm.deletePlace();
                    if (context.mounted) Navigator.pop(context, true);
                  }
                },
                child: const Text('Eliminar lugar',
                    style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
