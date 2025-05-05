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
  final controller = AddressController(AddressService());
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
      final lat = loc.latitude, lng = loc.longitude;

      final geoUri = Uri.parse('geo:$lat,$lng?q=${Uri.encodeComponent(fullAddress)}');
      debugPrint('Tentar geo: $geoUri');
      if (await canLaunchUrl(geoUri)) {
        await launchUrl(geoUri);
        return;
      }
      final mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
      debugPrint('Fazer fallback: $mapsUri');
      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
        return;
      }
      throw 'Não foi possível abrir o mapa';
    } catch (e, s) {
      debugPrint('Erro _openMap: $e\n$s');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A73FF), Color(0xFF6EA8FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'CEP (apenas números)',
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white54),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white38),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      final cep = cepController.text.trim();
                      if (cep.isNotEmpty) {
                        controller.fetchAddress(cep);
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: const Text('Buscar', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Observer(builder: (_) {
                  if (controller.loading) {
                    return const LoadingWidget();
                  }
                  if (controller.error != null) {
                    return shared.ErrorWidget(message: controller.error!);
                  }
                  if (controller.address != null) {
                    final a = controller.address!;
                    final fullAddress = '${a.logradouro}, ${a.bairro}, ${a.localidade} - ${a.uf}';
                    return Card(
                      color: Colors.white24,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CEP: ${a.cep}', style: const TextStyle(fontSize: 16, color: Colors.white)),
                            Text('Logradouro: ${a.logradouro}', style: const TextStyle(color: Colors.white70)),
                            Text('Complemento: ${a.complemento}', style: const TextStyle(color: Colors.white70)),
                            Text('Bairro: ${a.bairro}', style: const TextStyle(color: Colors.white70)),
                            Text('Cidade: ${a.localidade}', style: const TextStyle(color: Colors.white70)),
                            Text('UF: ${a.uf}', style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 12),
                            Center(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white38,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.map, color: Colors.white),
                                label: const Text('Traçar rota', style: TextStyle(color: Colors.white)),
                                onPressed: () => _openMap(fullAddress),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const Center(child: Text('Insira um CEP acima', style: TextStyle(color: Colors.white70)));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
