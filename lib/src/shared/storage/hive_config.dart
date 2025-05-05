import 'package:hive_flutter/hive_flutter.dart';
import 'package:fast_delivery/src/modules/home/model/address_model.dart';

class HiveConfig {
  static const historyBox = 'history_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(AddressModelAdapter());

    await Hive.openBox<AddressModel>(historyBox);
  }
}
