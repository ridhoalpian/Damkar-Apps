import 'package:flutter/material.dart';

class HalamanNotifikasi extends StatelessWidget {
  const HalamanNotifikasi({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data notifikasi dummy
    final List<Map<String, String>> notifikasi = [
      {
        'judul': 'Laporan diterima',
        'deskripsi': 'Laporan kebakaran di Jl. Mastrip sudah kami terima.',
        'waktu': '1 menit lalu',
      },
      {
        'judul': 'Tim sedang menuju lokasi',
        'deskripsi': 'Tim pemadam sedang dalam perjalanan ke lokasi kejadian.',
        'waktu': '5 menit lalu',
      },
      {
        'judul': 'Laporan berhasil dikirim',
        'deskripsi': 'Terima kasih sudah melapor. Kami segera tangani.',
        'waktu': '10 menit lalu',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifikasi.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = notifikasi[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['judul']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(item['deskripsi']!),
                const SizedBox(height: 8),
                Text(
                  item['waktu']!,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
