import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fast_delivery/src/modules/home/controller/address_controller.dart';
import 'package:fast_delivery/src/modules/home/service/address_service.dart';
import 'package:fast_delivery/src/modules/home/repositories/viacep_repository.dart';
import 'package:fast_delivery/src/modules/home/repositories/local_repository.dart';
import 'package:fast_delivery/src/shared/components/loading_widget.dart';
import 'package:fast_delivery/src/shared/components/error_widget.dart' as shared;
import 'package:fast_delivery/src/routes/app_routes.dart';

import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = AddressController(
    AddressService(
      remoteRepo: ViacepRepository(),
      localRepo: LocalRepository(),
    ),
  );
  final cepController = TextEditingController();

  @override
  void dispose() {
    cepController.dispose();
    super.dispose();
  }

  Future<void> _openMap(String fullAddress) async {
    try {
      final locations = await locationFromAddress(fullAddress);
      if (locations.isEmpty) return;
      final loc = locations.first;
      final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${loc.latitude},${loc.longitude}',
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Não foi possível abrir o mapa';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao abrir o mapa')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de CEP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.history),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cepController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CEP (apenas números)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final cep = cepController.text.trim();
                    if (cep.isNotEmpty) {
                      controller.fetchAddress(cep);
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Observer(builder: (_) {
              if (controller.loading) {
                return const LoadingWidget();
              }
              if (controller.error != null) {
                return shared.ErrorWidget(message: controller.error!);
              }
              if (controller.address != null) {
                final a = controller.address!;
                final fullAddress =
                    '${a.logradouro}, ${a.bairro}, ${a.localidade} - ${a.uf}';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CEP: ${a.cep}', style: const TextStyle(fontSize: 16)),
                    Text('Logradouro: ${a.logradouro}'),
                    Text('Complemento: ${a.complemento}'),
                    Text('Bairro: ${a.bairro}'),
                    Text('Cidade: ${a.localidade}'),
                    Text('UF: ${a.uf}'),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.map),
                      label: const Text('Traçar rota'),
                      onPressed: () => _openMap(fullAddress),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
