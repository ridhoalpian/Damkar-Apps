import 'package:damkarapps/halaman_awal/halaman_emergency.dart';
import 'package:damkarapps/halaman_awal/halaman_login.dart';
import 'package:damkarapps/halaman_awal/halaman_splash.dart';
import 'package:damkarapps/halaman_utama/halaman_utama.dart';
import 'package:flutter/material.dart'; // Tambahkan font_awesome_flutter di pubspec.yaml jika belum

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'Montserrat'), 
        bodyMedium: TextStyle(fontFamily: 'Montserrat'), 
      ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HalamanSplash(),
        '/emergency': (context) => HalamanEmergency(),
        '/home': (context) => HalamanUtama(),
        '/login': (context) => HalamanLogin()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
