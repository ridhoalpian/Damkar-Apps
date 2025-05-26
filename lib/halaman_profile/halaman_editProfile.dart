import 'dart:convert';
import 'package:damkarapps/file_tambahan/DBHelper.dart';
import 'package:damkarapps/file_tambahan/UserData.dart';
import 'package:damkarapps/file_tambahan/apiutils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HalamanEditProfile extends StatefulWidget {
  @override
  _HalamanEditProfileState createState() => _HalamanEditProfileState();
}

class _HalamanEditProfileState extends State<HalamanEditProfile> {
  int userId = 0;
  String emailUser = '';
  String namaUser = '';
  String noHP = '';

  TextEditingController _namaUserController = TextEditingController();
  TextEditingController _emailUserController = TextEditingController();
  TextEditingController _noHPController = TextEditingController();

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
              controller: _namaUserController,
              decoration: InputDecoration(
                labelText: 'Nama',
                prefixIcon: Icon(Icons.home, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailUserController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _noHPController,
              decoration: InputDecoration(
                labelText: 'No Telp',
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
                  backgroundColor: Colors.red,
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

  Future<void> _loadProfileData() async {
    List<Map<String, dynamic>> profileDataList = await DBHelper.getData();

    if (profileDataList.isNotEmpty) {
      Map<String, dynamic> profileDataMap = profileDataList.first;
      UserData profileData = UserData.fromJson(profileDataMap);

      setState(() {
        userId = profileData.id; // Assign the userId
        namaUser = profileData.name;
        emailUser = profileData.email;
        noHP = profileData.notlp;

        _namaUserController.text = namaUser;
        _emailUserController.text = emailUser;
        _noHPController.text = noHP;
      });
    } else {}
  }

  Future<void> updateProfile() async {
    String apiUrl = ApiUtils.buildUrl('api/update-user');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, String> body = {
      'id': userId.toString(),
      'name': _namaUserController.text,
      'email': _emailUserController.text,
      'notlp': _noHPController.text,
    };

    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Success, Data profile berhasil diubah')),
        );
        Navigator.of(context).pop();

        await _saveChangesToLocalDatabase();
      } else {
        print('Gagal mengubah data profile');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _saveChangesToLocalDatabase() async {
    Map<String, dynamic> newData = {
      'id': userId, // Add the id to the newData map
      'email': _emailUserController.text,
      'name': _namaUserController.text,
      'notlp': _noHPController.text,
    };

    await DBHelper.editUserData(userId, newData);
  }
}
