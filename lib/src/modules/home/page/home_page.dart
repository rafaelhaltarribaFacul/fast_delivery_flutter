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
      if (locations.isEmpty) throw 'Localização não encontrada';

      final loc = locations.first;
      final lat = loc.latitude;
      final lng = loc.longitude;

      final geoUri = Uri.parse('geo:$lat,$lng?q=${Uri.encodeComponent(fullAddress)}');
      debugPrint('Tentando abrir URI geo: $geoUri');
      if (await canLaunchUrl(geoUri)) {
        await launchUrl(geoUri);
        return;
      }

      final mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
      debugPrint('Fazendo fallback para navegador: $mapsUri');
      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
        return;
      }

      throw 'Não foi possível abrir o mapa em nenhuma forma';
    } catch (e, s) {
      debugPrint('Erro em _openMap: $e\n$s');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
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
