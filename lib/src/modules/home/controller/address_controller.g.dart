part of 'address_controller.dart';

mixin _$AddressController on _AddressControllerBase, Store {
  late final _$addressAtom =
      Atom(name: '_AddressControllerBase.address', context: context);

  @override
  AddressModel? get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(AddressModel? value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_AddressControllerBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$errorAtom =
      Atom(name: '_AddressControllerBase.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$historyAtom =
      Atom(name: '_AddressControllerBase.history', context: context);

  @override
  ObservableList<AddressModel> get history {
    _$historyAtom.reportRead();
    return super.history;
  }

  @override
  set history(ObservableList<AddressModel> value) {
    _$historyAtom.reportWrite(value, super.history, () {
      super.history = value;
    });
  }

  late final _$fetchAddressAsyncAction =
      AsyncAction('_AddressControllerBase.fetchAddress', context: context);

  @override
  Future<void> fetchAddress(String cep) {
    return _$fetchAddressAsyncAction.run(() => super.fetchAddress(cep));
  }

  late final _$_AddressControllerBaseActionController =
      ActionController(name: '_AddressControllerBase', context: context);

  @override
  void loadHistory() {
    final _$actionInfo = _$_AddressControllerBaseActionController.startAction(
        name: '_AddressControllerBase.loadHistory');
    try {
      return super.loadHistory();
    } finally {
      _$_AddressControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
address: ${address},
loading: ${loading},
error: ${error},
history: ${history}
    ''';
  }
}
