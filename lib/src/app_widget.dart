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
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),

      initialRoute: AppRoutes.splash,

      routes: {
        AppRoutes.splash: (context) => const SplashPage(),
        AppRoutes.home:   (context) => const HomePage(),
        AppRoutes.history:(context) => HistoryPage(),
      },
    );
  }
}
