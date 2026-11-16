import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'services/favorite_service.dart';
import 'services/session_service.dart';
import 'services/notification_service.dart';


Future<void> main() async {
  // Wajib kalau ada await sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive & buka box favorit
  await Hive.initFlutter();
  await Hive.openBox(FavoriteService.boxName);
  await NotificationService().init();

  // Cek apakah user sudah login sebelumnya
  final bool loggedIn = await SessionService().isLoggedIn();

  runApp(MyApp(isLoggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    const Color accent = Color(0xFFF44336);

    return MaterialApp(
      title: 'NontonSkuy!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(primary: accent),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: accent,
          unselectedItemColor: Colors.grey,
        ),
      ),
      // Sudah login -> langsung ke MainPage, belum -> LoginPage
      home: isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}