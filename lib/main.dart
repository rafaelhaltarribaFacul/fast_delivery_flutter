import 'package:flutter/material.dart';
import 'package:fast_delivery/src/app_widget.dart';
import 'package:fast_delivery/src/shared/storage/hive_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveConfig.init();

  runApp(const AppWidget());
}
