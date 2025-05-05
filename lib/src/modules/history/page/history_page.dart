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
    AddressService(
      remoteRepo: ViacepRepository(),
      localRepo: LocalRepository(),
    ),
  );

  Future<void> _openMap(BuildContext context, AddressModel address) async {
    final fullAddress =
        '${address.logradouro}, ${address.bairro}, ${address.localidade} - ${address.uf}';
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
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao abrir o mapa')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de CEP')),
      body: Observer(builder: (_) {
        final list = controller.history;
        if (list.isEmpty) {
          return const Center(child: Text('Nenhum CEP consultado ainda.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (_, index) {
            final addr = list[index];
            final subtitle =
                '${addr.logradouro}, ${addr.bairro}, ${addr.localidade} - ${addr.uf}';
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text('CEP: ${addr.cep}'),
                subtitle: Text(subtitle),
                trailing: IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: () => _openMap(context, addr),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
