import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:projectone/database/apiutils.dart';
// import 'package:damkarapps/halaman_awal/halaman_login.dart';

class PassBaru extends StatefulWidget {
  final String email;

  PassBaru({required this.email});

  @override
  _PassBaruState createState() => _PassBaruState();
}

class _PassBaruState extends State<PassBaru> {
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Buat Password Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40),
              Image.asset(
                'assets/images/passbaru.png',
                height: 150,
                width: 150,
              ),
              SizedBox(height: 40),
              Text(
                'Masukkan password baru anda. pastikan membuat password yang sulit ditebak',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: newPasswordController,
                obscureText: _isPasswordObscured,
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
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
                  suffixIcon: IconButton(
                    icon: _isConfirmPasswordObscured
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordObscured =
                            !_isConfirmPasswordObscured;
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => changePassword(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                  side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
                elevation: 10,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Kirim',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> changePassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      // Menampilkan pesan kesalahan jika form tidak valid
      AnimatedSnackBar.rectangle(
        'Error',
        'Periksa kembali form anda',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
      ).show(context);
      return;
    }

    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      AnimatedSnackBar.rectangle(
        'Info',
        'Konfirmasi Password tidak sesuai',
        type: AnimatedSnackBarType.info,
        brightness: Brightness.light,
      ).show(context);
      return;
    }

    // final Uri uri =  Uri.parse(ApiUtils.buildUrl('api/change-password'));
    // final response = await http.post(
    //   uri,
    //   body: {'email': widget.email, 'password': newPassword},
    // );

    // if (response.statusCode == 200) {
    //   AnimatedSnackBar.rectangle(
    //     'Success',
    //     'Password baru berhasil disimpan',
    //     type: AnimatedSnackBarType.success,
    //     brightness: Brightness.light,
    //   ).show(context);
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginPage()),
    //   );
    // } else {
    //   AnimatedSnackBar.rectangle(
    //     'Error',
    //     'Gagal menyimpan password baru',
    //     type: AnimatedSnackBarType.error,
    //     brightness: Brightness.light,
    //   ).show(context);
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginPage()),
    //   );
    // }
  }
}
