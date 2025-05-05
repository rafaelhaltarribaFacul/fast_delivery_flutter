import 'package:mobx/mobx.dart';
import 'package:fast_delivery/src/modules/home/model/address_model.dart';
import 'package:fast_delivery/src/modules/home/service/address_service.dart';

part 'history_controller.g.dart';

class HistoryController = _HistoryControllerBase with _$HistoryController;

abstract class _HistoryControllerBase with Store {
  final AddressService _service;

  _HistoryControllerBase(this._service) {
    loadHistory();
  }

  @observable
  ObservableList<AddressModel> history = ObservableList<AddressModel>();

  @action
  void loadHistory() {
    final list = _service.getHistory();
    history = ObservableList<AddressModel>.of(list.reversed);
  }
}
