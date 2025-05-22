import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:damkarapps/halaman_awal/verifikasi_email.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class HalamanLupaPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final EmailOTP myauth = EmailOTP();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lupa Password',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 40),
              Image.asset(
                'assets/images/',
                height: 150,
                width: 150,
              ),
              SizedBox(height: 40),
              Text(
                'Masukkan email yang digunakan pada saat pertama kali mendaftar',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Anda',
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email harus diisi';
                  }
                  final emailRegex =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Masukkan alamat email yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 60),
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  myauth.setConfig(
                    appEmail: "contact@hdevcoder.com",
                    appName: "Email OTP",
                    userEmail: emailController.text,
                    otpLength: 4,
                    otpType: OTPType.digitsOnly,
                  );
                  if (await myauth.sendOTP() == true) {
                    AnimatedSnackBar.rectangle(
                      'Success',
                      'OTP berhasil dikirim',
                      type: AnimatedSnackBarType.success,
                      brightness: Brightness.light,
                    ).show(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifOtpPage(
                          myauth: myauth,
                          email: emailController.text,
                        ),
                      ),
                    );
                  } else {
                    AnimatedSnackBar.rectangle(
                      'Error',
                      'OTP gagal dikirim',
                      type: AnimatedSnackBarType.error,
                      brightness: Brightness.light,
                    ).show(context);
                  }
                }
              },
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
}
