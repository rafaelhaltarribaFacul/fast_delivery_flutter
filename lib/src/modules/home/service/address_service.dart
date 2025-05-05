import 'package:fast_delivery/src/modules/home/model/address_model.dart';
import 'package:fast_delivery/src/modules/home/repositories/viacep_repository.dart';
import 'package:fast_delivery/src/modules/home/repositories/local_repository.dart';

class AddressService {
  final ViacepRepository _remoteRepo;
  final LocalRepository _localRepo;

  AddressService({
    ViacepRepository? remoteRepo,
    LocalRepository? localRepo,
  })  : _remoteRepo = remoteRepo ?? ViacepRepository(),
        _localRepo = localRepo ?? LocalRepository();

  Future<AddressModel> getAddress(String cep) async {
    final data = await _remoteRepo.fetchCep(cep);

    if (data.containsKey('erro') && data['erro'] == true) {
      throw Exception('CEP não encontrado');
    }

    final address = AddressModel.fromJson(data);
    await _localRepo.saveAddress(address);
    return address;
  }

  List<AddressModel> getHistory() {
    return _localRepo.getHistory();
  }
}
