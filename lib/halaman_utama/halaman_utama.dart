import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:damkarapps/berita_model.dart';
import 'package:damkarapps/file_tambahan/DBHelper.dart';
import 'package:damkarapps/file_tambahan/UserData.dart';
import 'package:damkarapps/file_tambahan/apiutils.dart';
import 'package:damkarapps/halaman_profile/halaman_profile.dart';
import 'package:damkarapps/halaman_utama/halaman_chatbot.dart';
import 'package:damkarapps/halaman_utama/halaman_lokasi.dart';
import 'package:damkarapps/kategoributton.dart';
import 'package:damkarapps/halaman_utama/halaman_videotutorial.dart';
import 'package:damkarapps/launchWA.dart';
import 'package:damkarapps/launchdialer.dart';
import 'package:damkarapps/youtube_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:damkarapps/halaman_utama/halaman_detailberita.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HalamanUtama extends StatefulWidget {
  @override
  _HalamanUtamaState createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  List<Berita> beritaList = [];
  List<YoutubeVideo> youtubeList = [];
  String namaUser = '';
  String idUser = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    fetchBerita();
    fetchYoutube();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchBerita();
      fetchYoutube();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchBerita() async {
    final response =
        await http.get(Uri.parse(ApiUtils.buildUrl('api/beritaapi')));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        beritaList = data.map((e) => Berita.fromJson(e)).toList();
      });
    }
  }

  Future<void> fetchYoutube() async {
    final response =
        await http.get(Uri.parse(ApiUtils.buildUrl('api/youtubeapi')));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        youtubeList = data.map((e) => YoutubeVideo.fromJson(e)).toList();
      });
    }
  }

  Widget youtubeCard(String url) {
    final cleanedUrl = url.split('?').first;
    final videoId = YoutubePlayer.convertUrlToId(cleanedUrl);

    if (videoId == null || videoId.isEmpty) {
      print('Gagal konversi link YouTube: $url');
      return const Text('Video tidak tersedia');
    }

    final controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return Column(
          children: [
            player,
          ],
        );
      },
    );
  }

  Future<void> _loadProfileData() async {
    List<Map<String, dynamic>> profileDataList = await DBHelper.getData();

    if (profileDataList.isNotEmpty) {
      Map<String, dynamic> profileDataMap = profileDataList.first;
      UserData profileData = UserData.fromJson(profileDataMap);

      setState(() {
        namaUser = profileData.name;
        idUser = profileData.id.toString();
      });
    } else {}
  }

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
                      child: Text.rich(
                        TextSpan(
                          text: "Selamat Datang, ",
                          children: [
                            TextSpan(
                              text: namaUser + "!",
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
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.1),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.2),
                    ),
                  ),
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
                                jenis_kebakaran: 'Hewan Buas')),
                      );
                    },
                  ),
                  KategoriButton(
                    icon: Icons.volcano, 
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
                height: 220,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: youtubeList.map((yt) {
                      final videoId =
                          YoutubePlayer.convertUrlToId(yt.linkYoutube) ?? '';
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: tutorialItem(
                          videoId: videoId,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HalamanVideoTutorial(url: yt.linkYoutube),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
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
                height: 320,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: beritaList
                        .take(3)
                        .map((berita) => beritaItem(
                              imageUrl: berita.foto,
                              title: berita.judul,
                              summary: berita.isi,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailBeritaPage(berita: berita),
                                  ),
                                );
                              },
                            ))
                        .toList(),
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
    required VoidCallback onTap,
  }) {
    final String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

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
                thumbnailUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
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
        },
      ),
    );
  }
}
