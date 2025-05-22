import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:damkarapps/file_tambahan/DBHelper.dart';
import 'package:damkarapps/file_tambahan/UserData.dart';
import 'package:damkarapps/file_tambahan/apiutils.dart';
import 'package:http/http.dart' as http;

class HalamanPasswordBaru extends StatefulWidget {
  @override
  _HalamanPasswordBaruState createState() => _HalamanPasswordBaruState();
}

class _HalamanPasswordBaruState extends State<HalamanPasswordBaru> {
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  String emailUKM = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> _loadProfileData() async {
    List<Map<String, dynamic>> profileDataList = await DBHelper.getUKMData();

    if (profileDataList.isNotEmpty) {
      Map<String, dynamic> profileDataMap = profileDataList.first;
      UserData profileData = UserData.fromJson(profileDataMap);

      setState(() {
        emailUKM = profileData.email;
      });
    } else {}
  }

  Future<void> _changePassword() async {
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Periksa apakah password baru dan konfirmasi password cocok
    if (newPassword != confirmPassword) {
      AnimatedSnackBar.rectangle(
        'Warning',
        'Password dan konfirmasi password tidak cocok',
        type: AnimatedSnackBarType.warning,
        brightness: Brightness.light,
        duration: Duration(seconds: 6),
      ).show(context);

      return;
    }

    // Kirim permintaan ke API untuk mengubah password
    try {
      var response = await http.post(
        Uri.parse(ApiUtils.buildUrl('api/change-password')),
        body: {'email': emailUKM, 'password': newPassword},
      );

      // Periksa status kode respons
      if (response.statusCode == 200) {
        AnimatedSnackBar.rectangle(
          'Success',
          'Password berhasil diperbarui',
          type: AnimatedSnackBarType.success,
          brightness: Brightness.light,
          duration: Duration(seconds: 4),
        ).show(context);

        Navigator.of(context).pop();
      } else {
        AnimatedSnackBar.rectangle(
          'Warning',
          'Gagal memperbarui password',
          type: AnimatedSnackBarType.warning,
          brightness: Brightness.light,
          duration: Duration(seconds: 4),
        ).show(context);
      }
    } catch (e) {
      print('Error: $e');
      AnimatedSnackBar.rectangle(
        'Info',
        'Terjadi kesalahan, silakan coba lagi',
        type: AnimatedSnackBarType.info,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Password Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: newPasswordController,
              obscureText: _isPasswordObscured,
              decoration: InputDecoration(
                labelText: 'Password Baru',
                prefixIcon: Icon(Icons.lock, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: IconButton(
                  icon: _isPasswordObscured
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password harus diisi';
                }
                if (value.length < 8) {
                  return 'Password harus memiliki setidaknya 8 karakter';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: _isConfirmPasswordObscured,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password',
                prefixIcon: Icon(Icons.lock, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: IconButton(
                  icon: _isConfirmPasswordObscured
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi password harus diisi';
                }
                if (value != newPasswordController.text) {
                  return 'Konfirmasi password tidak cocok';
                }
                return null;
              },
            ),
            SizedBox(height: 30),
            Container(
              height: 60,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _changePassword();
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF5F7C5D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                    side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  ),
                  elevation: 10,
                  shadowColor: Colors.grey.withOpacity(0.2),
                ),
                child: Text(
                  "Simpan Perubahan",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
