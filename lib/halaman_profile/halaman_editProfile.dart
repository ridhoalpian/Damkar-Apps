import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:damkarapps/file_tambahan/DBHelper.dart';
import 'package:damkarapps/file_tambahan/UserData.dart';
import 'package:damkarapps/file_tambahan/apiutils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HalamanEditProfile extends StatefulWidget {
  @override
  _HalamanEditProfileState createState() => _HalamanEditProfileState();
}

class _HalamanEditProfileState extends State<HalamanEditProfile> {
  int userId = 0;
  String emailUKM = '';
  String namaUKM = '';
  String namaKetua = '';

  // Controllers for TextFields
  TextEditingController _namaUKMController = TextEditingController();
  TextEditingController _emailUKMController = TextEditingController();
  TextEditingController _namaKetuaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
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
            TextField(
              controller: _namaUKMController,
              decoration: InputDecoration(
                labelText: 'Nama UKM',
                prefixIcon: Icon(Icons.home, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailUKMController,
              decoration: InputDecoration(
                labelText: 'Email UKM',
                prefixIcon: Icon(Icons.email, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _namaKetuaController,
              decoration: InputDecoration(
                labelText: 'Nama Ketua',
                prefixIcon: Icon(Icons.person, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 60,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  updateProfile();
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

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _loadProfileData() async {
    List<Map<String, dynamic>> profileDataList = await DBHelper.getUKMData();

    if (profileDataList.isNotEmpty) {
      Map<String, dynamic> profileDataMap = profileDataList.first;
      UserData profileData = UserData.fromJson(profileDataMap);

      setState(() {
        userId = profileData.id; // Assign the userId
        namaUKM = profileData.name;
        emailUKM = profileData.email;
        namaKetua = profileData.ketua;

        _namaUKMController.text = namaUKM;
        _emailUKMController.text = emailUKM;
        _namaKetuaController.text = namaKetua;
      });
    } else {
      // Handle case when no profile data is found
    }
  }

  Future<void> updateProfile() async {
    String apiUrl = ApiUtils.buildUrl('api/update-user');
    String? token = await _getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    Map<String, String> body = {
      'name': _namaUKMController.text,
      'email': _emailUKMController.text,
      'ketua': _namaKetuaController.text,
    };

    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        print('User data updated successfully');
        AnimatedSnackBar.rectangle(
          'Success',
          'Data profile berhasil diubah',
          type: AnimatedSnackBarType.success,
          brightness: Brightness.light,
          duration: Duration(seconds: 4),
        ).show(context);

        Navigator.of(context).pop(); // Kembali ke layar sebelumnya

        // Simpan perubahan data ke dalam database sqflite
        await _saveChangesToLocalDatabase();
      } else {
        print('Failed to update user data: ${response.statusCode}');
        // Tambahkan penanganan kesalahan jika diperlukan
      }
    } catch (error) {
      print('Error: $error');
      // Tambahkan penanganan kesalahan jika diperlukan
    }
  }

  Future<void> _saveChangesToLocalDatabase() async {
    Map<String, dynamic> newData = {
      'id': userId, // Add the id to the newData map
      'email': _emailUKMController.text,
      'name': _namaUKMController.text,
      'ketua': _namaKetuaController.text,
    };

    await DBHelper.editUserData(userId, newData);
  }
}
