import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

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
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final List<File> _fotoList = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _fotoList.add(File(picked.path));
      });
    }
  }

  Future<void> _submitLaporan() async {
    final uri = Uri.parse(
        "http://10.0.2.2:8000/api/laporan"); // ganti IP jika real device
    final request = http.MultipartRequest("POST", uri);

    request.fields['nama_pelapor'] = _namaController.text;
    request.fields['no_hp_pelapor'] = _teleponController.text;
    request.fields['jenis_kebakaran'] = widget.jenisKebakaran;
    request.fields['lokasi'] = 'Lokasi pelapor'; // bisa pakai Google Maps API
    request.fields['lat'] = widget.latitude.toString();
    request.fields['lng'] = widget.longitude.toString();
    request.fields['catatan'] = _deskripsiController.text;
    request.fields['status'] = 'menunggu';

    for (var i = 0; i < _fotoList.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
        'foto[]',
        _fotoList[i].path,
      ));
    }

    setState(() => _isLoading = true);
    final response = await request.send();
    setState(() => _isLoading = false);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Laporan berhasil dikirim")),
      );
      Navigator.pop(context);
    } else {
      final respStr = await response.stream.bytesToString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengirim: $respStr")),
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
                children: [
                  ..._fotoList.map((file) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(file,
                            width: 60, height: 60, fit: BoxFit.cover),
                      )),
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
            const SizedBox(height: 16),
            const Text("Lokasi Pelapor",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            const SizedBox(height: 8),
            Text("Latitude: ${widget.latitude}"),
            Text("Longitude: ${widget.longitude}"),
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
}
