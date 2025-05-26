import 'package:damkarapps/file_tambahan/DBHelper.dart';
import 'package:damkarapps/file_tambahan/UserData.dart';
import 'package:damkarapps/file_tambahan/apiutils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class HalamanKejadian extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String jenisKebakaran;

  const HalamanKejadian({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.jenisKebakaran,
  });

  @override
  State<HalamanKejadian> createState() => _HalamanKejadianState();
}

class _HalamanKejadianState extends State<HalamanKejadian> {
  int userId = 0;
  String emailUser = '';
  String namaUser = '';
  String noHP = '';

  // Controllers for TextFields
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _lokasiDetailController = TextEditingController();
  final List<File> _fotoList = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    final now = DateTime.now();
    final formattedDateTime =
        "${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)} ${_twoDigits(now.hour)}:${_twoDigits(now.minute)}";
    _waktuController.text = formattedDateTime;
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _fotoList.add(File(picked.path));
      });
    }
  }

  Future<void> _takePhoto() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // ⬅ bisa diturunkan agar ukuran file kecil
        preferredCameraDevice: CameraDevice.rear,
      );
      if (picked != null) {
        setState(() {
          _fotoList.add(File(picked.path));
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin kamera ditolak")),
      );
    }
  }

  Future<void> _submitLaporan() async {
    if (_namaController.text.isEmpty ||
        _teleponController.text.isEmpty ||
        _waktuController.text.isEmpty ||
        _deskripsiController.text.isEmpty ||
        _lokasiDetailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap lengkapi semua data!")),
      );
      return;
    }

    final uri = Uri.parse(ApiUtils.buildUrl('api/laporankej'));
    final request = http.MultipartRequest("POST", uri);

    request.fields['nama_pelapor'] = _namaController.text;
    request.fields['notlp'] = _teleponController.text;
    request.fields['waktu_lapor'] = _waktuController.text;
    request.fields['jenis_kebakaran'] = widget.jenisKebakaran;
    request.fields['lat'] = widget.latitude.toString();
    request.fields['lng'] = widget.longitude.toString();
    request.fields['lokasi'] =
        _lokasiDetailController.text; // ⬅ Lokasi ditambahkan
    request.fields['catatan'] = _deskripsiController.text;

    for (var i = 0; i < _fotoList.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
        'foto[]',
        _fotoList[i].path,
      ));
    }

    setState(() => _isLoading = true);
    try {
      final response = await request.send();
      setState(() => _isLoading = false);

      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Laporan berhasil dikirim")),
        );
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      } else {
        debugPrint("RESP ERROR: $respStr");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengirim laporan: $respStr")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("ERROR EXCEPTION: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  Widget _buildInputField(String hint, TextEditingController controller,
      {int maxLines = 1, bool readOnly = false}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Kejadian",
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Masukkan Laporan Anda!!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            _buildInputField("Nama Pelapor", _namaController),
            const SizedBox(height: 12),
            _buildInputField("No. Telepon / No. HP", _teleponController),
            const SizedBox(height: 12),
            _buildInputField("Waktu Kejadian", _waktuController,
                readOnly: true),
            const SizedBox(height: 12),
            _buildInputField("Lokasi Detail", _lokasiDetailController),
            const SizedBox(height: 12),
            _buildInputField("Deskripsi Kejadian", _deskripsiController,
                maxLines: 4),
            const SizedBox(height: 16),
            const Text("Unggah Foto",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._fotoList.asMap().entries.map((entry) {
                    int index = entry.key;
                    File file = entry.value;

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            file,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: -6,
                          top: -6,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _fotoList.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.photo_library),
                    ),
                  ),
                  GestureDetector(
                    onTap: _takePhoto,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitLaporan,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Kirim"),
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
        noHP = profileData.notlp;

        _namaController.text = namaUser;
        _teleponController.text = noHP;
      });
    } else {
      // Handle case when no profile data is found
    }
  }
}
