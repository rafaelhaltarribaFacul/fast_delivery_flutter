import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fast_delivery/src/modules/home/model/address_model.dart';
import 'package:fast_delivery/src/modules/home/repositories/viacep_repository.dart';
import 'package:fast_delivery/src/modules/home/service/address_service.dart';
import 'package:fast_delivery/src/modules/home/repositories/local_repository.dart';

class MockViacepRepository extends Mock implements ViacepRepository {}
class MockLocalRepository extends Mock implements LocalRepository {}

void main() {
  late MockViacepRepository mockRemote;
  late MockLocalRepository mockLocal;
  late AddressService service;

  setUp(() {
    mockRemote = MockViacepRepository();
    mockLocal  = MockLocalRepository();
    service    = AddressService(
      remoteRepo: mockRemote,
      localRepo: mockLocal,
    );
  });

  test('getAddress retorna modelo válido para CEP existente', () async {
    final json = {
      'cep': '01001-000',
      'logradouro': 'Praça da Sé',
      'complemento': 'lado ímpar',
      'bairro': 'Sé',
      'localidade': 'São Paulo',
      'uf': 'SP',
    };
    when(() => mockRemote.fetchCep('01001000'))
      .thenAnswer((_) async => json);

    final result = await service.getAddress('01001000');

    expect(result, isA<AddressModel>());
    expect(result.cep, '01001-000');
    expect(result.localidade, 'São Paulo');
    verify(() => mockLocal.saveAddress(result)).called(1);
  });

  test('getAddress lança exceção para CEP não encontrado', () async {
    when(() => mockRemote.fetchCep('00000000'))
      .thenAnswer((_) async => {'erro': true});

    expect(
      () => service.getAddress('00000000'),
      throwsA(isA<Exception>().having((e) => e.toString(), 'msg', contains('CEP não encontrado')))
    );
    verifyNever(() => mockLocal.saveAddress(any()));
  });
}
