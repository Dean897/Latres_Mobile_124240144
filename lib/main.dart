import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/storage_service.dart';
import 'theme/app_colors.dart';
import 'views/login_view.dart';
import 'views/main_nav_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<Map>('favorites_box');
  final preferences = await SharedPreferences.getInstance();
  final isLoggedIn = preferences.getBool(StorageService.loginKey) ?? false;

  runApp(NontonSkuyApp(isLoggedIn: isLoggedIn));
}

class NontonSkuyApp extends StatelessWidget {
  const NontonSkuyApp({required this.isLoggedIn, super.key});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NontonSkuy!',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const MainNavView() : const LoginView(),
    );
  }
}
