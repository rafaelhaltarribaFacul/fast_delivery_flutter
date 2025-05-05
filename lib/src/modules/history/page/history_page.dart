import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fast_delivery/src/modules/history/controller/history_controller.dart';
import 'package:fast_delivery/src/modules/home/service/address_service.dart';
import 'package:fast_delivery/src/modules/home/repositories/viacep_repository.dart';
import 'package:fast_delivery/src/modules/home/repositories/local_repository.dart';
import 'package:fast_delivery/src/modules/home/model/address_model.dart';

import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

  final HistoryController controller = HistoryController(
    AddressService(remoteRepo: ViacepRepository(), localRepo: LocalRepository()),
  );

  Future<void> _openMap(BuildContext context, AddressModel address) async {
    final fullAddress = '${address.logradouro}, ${address.bairro}, ${address.localidade} - ${address.uf}';
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
      debugPrint('Fallback web: $mapsUri');
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
          colors: [Color(0xFF6EA8FF), Color(0xFF0A73FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Histórico de CEP')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Observer(builder: (_) {
            final list = controller.history;
            if (list.isEmpty) {
              return const Center(child: Text('Nenhum CEP consultado ainda.', style: TextStyle(color: Colors.white70)));
            }
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, idx) {
                final addr = list[idx];
                final subtitle = '${addr.logradouro}, ${addr.bairro}, ${addr.localidade} - ${addr.uf}';
                return Card(
                  color: Colors.white24,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text('CEP: ${addr.cep}', style: const TextStyle(color: Colors.white)),
                    subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
                    trailing: IconButton(
                      icon: const Icon(Icons.map, color: Colors.white),
                      onPressed: () => _openMap(context, addr),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
