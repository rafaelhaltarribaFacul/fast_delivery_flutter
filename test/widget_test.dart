// test/widget_test.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fast_delivery/src/app_widget.dart';
import 'package:fast_delivery/src/modules/home/model/address_model.dart';
import 'package:fast_delivery/src/shared/storage/hive_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Directory tempDir = Directory.systemTemp.createTempSync();

  setUpAll(() async {
    // Mock do path_provider para testes Hive
    const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
    pathProviderChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        // Retorna somente o path como String
        return tempDir.path;
      }
      return null;
    });

    // Inicializa Hive para Flutter
    await Hive.initFlutter();
    Hive.registerAdapter(AddressModelAdapter());
    await Hive.openBox<AddressModel>(HiveConfig.historyBox);
  });

  tearDownAll(() async {
    if (Hive.isBoxOpen(HiveConfig.historyBox)) {
      final box = Hive.box<AddressModel>(HiveConfig.historyBox);
      await box.clear();
    }
  });

  testWidgets('Exibe a splash com FlutterLogo', (WidgetTester tester) async {
    await tester.pumpWidget(const AppWidget());

    expect(find.byType(FlutterLogo), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
  });
}
