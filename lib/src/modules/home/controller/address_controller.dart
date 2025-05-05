import 'package:mobx/mobx.dart';
import 'package:fast_delivery/src/modules/home/model/address_model.dart';
import 'package:fast_delivery/src/modules/home/service/address_service.dart';

part 'address_controller.g.dart';

class AddressController = _AddressControllerBase with _$AddressController;

abstract class _AddressControllerBase with Store {
  final AddressService _service;

  _AddressControllerBase(this._service) {
    loadHistory();
  }

  @observable
  AddressModel? address;

  @observable
  bool loading = false;

  @observable
  String? error;

  @observable
  ObservableList<AddressModel> history = ObservableList<AddressModel>();

  @action
  Future<void> fetchAddress(String cep) async {
    loading = true;
    error = null;
    try {
      final fetched = await _service.getAddress(cep);
      address = fetched;
      loadHistory();
    } catch (e) {
      error = 'CEP não encontrado';
    } finally {
      loading = false;
    }
  }

  @action
  void loadHistory() {
    final list = _service.getHistory();
    history = ObservableList<AddressModel>.of(list.reversed);
  }
}
