import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:damkarapps/halaman_awal/pass_baru.dart';
import 'dart:async';

class VerifOtpPage extends StatefulWidget {
  final EmailOTP myauth;
  final String email;

  VerifOtpPage({required this.myauth, required this.email});

  @override
  _VerifOtpPageState createState() => _VerifOtpPageState();
}

class _VerifOtpPageState extends State<VerifOtpPage> {
  final TextEditingController otp1Controller = TextEditingController();
  final TextEditingController otp2Controller = TextEditingController();
  final TextEditingController otp3Controller = TextEditingController();
  final TextEditingController otp4Controller = TextEditingController();

  bool _isResendButtonEnabled = true;
  int _resendCountdown = 0;
  Timer? _timer;

  @override
  void dispose() {
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _isResendButtonEnabled = false;
      _resendCountdown = 180;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendCountdown == 0) {
        timer.cancel();
        setState(() {
          _isResendButtonEnabled = true;
        });
      } else {
        setState(() {
          _resendCountdown--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Verifikasi OTP',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 40),
            Image.asset(
              'assets/images/otpverif.png',
              height: 250,
              width: 250,
            ),
            SizedBox(height: 40),
            Text(
              'Masukkan kode OTP yang telah dikirimkan ke email Anda',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildOtpTextField(otp1Controller, otp1FocusNode),
                buildOtpTextField(otp2Controller, otp2FocusNode),
                buildOtpTextField(otp3Controller, otp3FocusNode),
                buildOtpTextField(otp4Controller, otp4FocusNode),
              ],
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                if (_isResendButtonEnabled) {
                  widget.myauth.setConfig(
                      appEmail: "contact@hdevcoder.com",
                      appName: "Email OTP",
                      userEmail: widget.email,
                      otpLength: 4,
                      otpType: OTPType.digitsOnly);
                  if (await widget.myauth.sendOTP() == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Success, OTP berhasil dikirim')),
                    );
                    _startResendTimer();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error, OTP gagal dikirim')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Warning, Anda dapat mengirim ulang kode OTP setelah waktu tunggu habis')),
                  );
                }
              },
              child: Text(
                _isResendButtonEnabled
                    ? "Kirim ulang kode OTP"
                    : "Kirim ulang kode OTP dapat dilakukan kembali dalam ($_resendCountdown) detik",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                String otp = otp1Controller.text +
                    otp2Controller.text +
                    otp3Controller.text +
                    otp4Controller.text;

                if (await widget.myauth.verifyOTP(otp: otp)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Success, OTP berhasil diverifikasi')),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PassBaru(email: widget.email)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Error, Kode OTP tidak sesuai')),
                  );
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
                'Verifikasi',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
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

  // FocusNode untuk setiap TextField
  final FocusNode otp1FocusNode = FocusNode();
  final FocusNode otp2FocusNode = FocusNode();
  final FocusNode otp3FocusNode = FocusNode();
  final FocusNode otp4FocusNode = FocusNode();

  Widget buildOtpTextField(
      TextEditingController controller, FocusNode focusNode) {
    return Container(
      width: 60,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        onChanged: (value) {
          _onChanged(value, focusNode);
        },
      ),
    );
  }

  void _onChanged(String value, FocusNode focusNode) {
    if (value.isNotEmpty) {
      focusNode.nextFocus();
    }
  }
}
