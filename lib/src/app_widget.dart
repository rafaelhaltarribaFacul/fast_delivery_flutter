import 'package:flutter/material.dart';
import 'package:fast_delivery/src/routes/app_routes.dart';
import 'package:fast_delivery/src/modules/initial/page/splash_page.dart';
import 'package:fast_delivery/src/modules/home/page/home_page.dart';
import 'package:fast_delivery/src/modules/history/page/history_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_)   => SplashPage(),
        AppRoutes.home: (_)     => HomePage(),
        AppRoutes.history: (_)  => HistoryPage(),
      },
    );
  }
}
