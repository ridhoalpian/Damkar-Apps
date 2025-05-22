import 'package:damkarapps/halaman_profile/halaman_profile.dart';
import 'package:damkarapps/halaman_utama/halaman_chatbot.dart';
import 'package:damkarapps/halaman_utama/halaman_lokasi.dart';
import 'package:damkarapps/halaman_utama/halaman_notif.dart';
import 'package:damkarapps/kategoributton.dart';
import 'package:damkarapps/halaman_utama/halaman_videotutorial.dart';
import 'package:damkarapps/launchWA.dart';
import 'package:damkarapps/launchdialer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:damkarapps/halaman_utama/halaman_detailberita.dart';

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Selamat Datang
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text.rich(
                        TextSpan(
                          text: "Selamat Datang ",
                          children: [
                            TextSpan(
                              text: "Ridho!!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HalamanNotifikasi()),
                      );
                    },
                    child: const Icon(Icons.notifications, color: Colors.red),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChatBot()),
                      );
                    },
                    child: const Icon(Icons.message, color: Colors.red),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HalamanProfile()),
                      );
                    },
                    child: const Icon(Icons.person, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              const Text(
                'Apa kamu dalam situasi darurat?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Lingkaran besar (outer ripple)
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.1),
                    ),
                  ),
                  // Lingkaran tengah
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.2),
                    ),
                  ),
                  // Lingkaran kecil dengan icon
                  GestureDetector(
                    onTap: launchDialer,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.red, Colors.redAccent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: const Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Gunakan tombol di atas untuk memanggil petugas damkar segera dalam situasi darurat.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: launchWhatsApp,
                icon: const FaIcon(FontAwesomeIcons.whatsapp,
                    color: Colors.green),
                label: const Text("Hubungi Via Whatsapp ?"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Untuk laporan yang tidak mendesak, hubungi kami via WhatsApp.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Kategori laporan",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),

              const SizedBox(height: 16),

              Column(
                children: [
                  KategoriButton(
                    icon: Icons.warning_amber_rounded,
                    label: "Penyelamatan",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HalamanLokasi(
                                jenis_kebakaran: 'Penyelamatan')),
                      );
                    },
                  ),
                  KategoriButton(
                    icon: Icons.pets,
                    label: "Hewan Buas",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HalamanLokasi(
                                jenis_kebakaran: 'Hewan Buah')),
                      );
                    },
                  ),
                  KategoriButton(
                    icon: Icons.volcano, // atau FontAwesomeIcons.volcano
                    label: "Bencana Alam",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HalamanLokasi(
                                jenis_kebakaran: 'Bencana Alam')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Tutorial",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),

              SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      tutorialItem(
                        videoId: 'qS1IfnVLNJ8',
                        title: 'Prosedur Aman Penggunaan APAR',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TutorialVideoPage(
                                videoId: 'qS1IfnVLNJ8',
                                title: 'Prosedur Aman Penggunaan APAR',
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      tutorialItem(
                        videoId: 'Bd-zlTQkj_M',
                        title:
                            'Cara evakuasi saat kebakaran - Fire Fighter Training',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TutorialVideoPage(
                                videoId: 'Bd-zlTQkj_M',
                                title:
                                    'Cara evakuasi saat kebakaran - Fire Fighter Training',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Berita Penyelamatan",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      beritaItem(
                        imageUrl:
                            'https://img.okezone.com/content/2025/04/28/338/3134360/ilustrasi_kebakaran-AkXw_large.jpg',
                        title: 'Petugas Damkar Selamatkan Bayi dari Kebakaran',
                        summary: 'Dalam peristiwa kebakaran di kawasan X...',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DetailBeritaPage(
                                imageUrl:
                                    'https://img.okezone.com/content/2025/04/28/338/3134360/ilustrasi_kebakaran-AkXw_large.jpg',
                                title:
                                    'Petugas Damkar Selamatkan Bayi dari Kebakaran',
                                content:
                                    'Dalam peristiwa kebakaran di kawasan X, petugas pemadam kebakaran berhasil menyelamatkan seorang bayi dari dalam rumah yang terbakar. Evakuasi dilakukan dengan cepat setelah mendapat laporan dari warga...',
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      beritaItem(
                        imageUrl:
                            'https://img.okezone.com/content/2025/04/28/338/3134360/ilustrasi_kebakaran-AkXw_large.jpg',
                        title: 'Petugas Damkar Selamatkan Bayi dari Kebakaran',
                        summary: 'Dalam peristiwa kebakaran di kawasan X...',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DetailBeritaPage(
                                imageUrl:
                                    'https://img.okezone.com/content/2025/04/28/338/3134360/ilustrasi_kebakaran-AkXw_large.jpg',
                                title:
                                    'Petugas Damkar Selamatkan Bayi dari Kebakaran',
                                content:
                                    'Dalam peristiwa kebakaran di kawasan X, petugas pemadam kebakaran berhasil menyelamatkan seorang bayi dari dalam rumah yang terbakar. Evakuasi dilakukan dengan cepat setelah mendapat laporan dari warga...',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget beritaItem({
    required String imageUrl,
    required String title,
    required String summary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(top: 16, right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tutorialItem({
    required String videoId,
    required String title,
    required VoidCallback onTap,
  }) {
    final String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280, // Tambahkan ini
        margin: const EdgeInsets.only(top: 16, right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget kategoriItem({required IconData icon, required String label}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(label),
        onTap: () {
          // Aksi ketika kategori dipilih
        },
      ),
    );
  }
}
