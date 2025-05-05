import 'package:hive_flutter/hive_flutter.dart';
import 'package:fast_delivery/src/shared/storage/hive_config.dart';
import 'package:fast_delivery/src/modules/home/model/address_model.dart';

class LocalRepository {
  List<AddressModel> getHistory() {
    final box = Hive.box<AddressModel>(HiveConfig.historyBox);
    return box.values.toList();
  }

  Future<void> saveAddress(AddressModel address) async {
    final box = Hive.box<AddressModel>(HiveConfig.historyBox);
    final existingKey = box.values
        .cast<AddressModel>()
        .firstWhere(
          (e) => e.cep == address.cep,
          orElse: () => AddressModel(
            cep: '',
            logradouro: '',
            complemento: '',
            bairro: '',
            localidade: '',
            uf: '',
          ),
        )
        .key as dynamic;
    if (existingKey != null && existingKey != '') {
      await box.delete(existingKey);
    }
    await box.add(address);
  }
}
