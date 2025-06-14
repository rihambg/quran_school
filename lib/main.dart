import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'testpage.dart';
import 'package:get/get.dart';
import 'system/utils/theme.dart';
import 'controllers/theme.dart';
import 'routes/app_screens.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'bindings/starter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


Future<void> main() async {
  await dotenv.load(fileName: ".env"); // Load .env file
  dev.log('Environment variables loaded: ${dotenv.env}');
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeController.mode.value,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          initialBinding: StarterBinding(),
          getPages: AppScreens.routes,
          home: TestPage(),
           localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar'), // Arabic
            Locale('en'), // English
          ],
          locale: const Locale('ar'),
        ));
  }
}

// https://rydmike.com/flexcolorscheme/themesplayground-latest/
