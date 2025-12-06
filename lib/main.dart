import 'package:flutter/material.dart';
import 'ui/login_page.dart';
import 'ui/registrasi_page.dart';
import 'ui/inventaris_list_page.dart';
import 'ui/inventaris_form_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsi 2 Mobile Paket 1 (NIM)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // matikan material3 biar style lebih “normal”
        useMaterial3: false,

        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white, // judul appbar putih
        ),

        // pastikan teks default berwarna hitam
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
        ),

        // pastikan label & hint textField kelihatan
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.black54),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),

        // tombol abu-abu, teks putih jelas
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: const StadiumBorder(),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegistrasiPage(),
        '/inventaris': (_) => const InventarisListPage(),
        '/inventaris_form': (_) => const InventarisFormPage(),
      },
    );
  }
}
