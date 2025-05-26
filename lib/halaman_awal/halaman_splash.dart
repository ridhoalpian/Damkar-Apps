import 'package:damkarapps/file_tambahan/DBHelper.dart';
import 'package:damkarapps/halaman_awal/halaman_emergency.dart';
import 'package:damkarapps/halaman_utama/halaman_utama.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HalamanSplash extends StatefulWidget {
  const HalamanSplash({Key? key}) : super(key: key);

  @override
  _HalamanSplashState createState() => _HalamanSplashState();
}

class _HalamanSplashState extends State<HalamanSplash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      checkLoginStatus();
    });
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    final user = await DBHelper.getUser();

    if (email != null && user != null && user['email'] == email) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HalamanUtama()),
      );
    } else {
      await prefs.remove('email');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HalamanEmergency()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/icons/logo_damkar.png', width: 150),
      ),
    );
  }
}
