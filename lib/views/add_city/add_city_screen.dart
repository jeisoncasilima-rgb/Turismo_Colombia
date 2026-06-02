import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guia_turistica/data/repositories/place_repository_impl.dart';
import 'package:guia_turistica/presentation/viewmodels/add_city_viewmodel.dart';

class AddCityScreen extends StatelessWidget {
  const AddCityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<PlaceRepositoryImpl>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => AddCityViewModel(repository),
      child: const _AddCityForm(),
    );
  }
}

class _AddCityForm extends StatelessWidget {
  const _AddCityForm();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddCityViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar ciudad')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Nombre de la ciudad *'),
              controller: vm.nameController,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration:
                        const InputDecoration(labelText: 'Latitud (centro)'),
                    controller: vm.latController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration:
                        const InputDecoration(labelText: 'Longitud (centro)'),
                    controller: vm.lngController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: vm.isLoading
                  ? null
                  : () async {
                      final success = await vm.saveCity();
                      if (success && context.mounted) {
                        Navigator.pop(context, true);
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('El nombre es obligatorio')),
                        );
                      }
                    },
              child: vm.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Guardar ciudad'),
            ),
          ],
        ),
      ),
    );
  }
}
