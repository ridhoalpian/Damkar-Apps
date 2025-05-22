import 'package:flutter/material.dart';
import 'package:damkarapps/halaman_utama/halaman_videotutorial.dart';

class HalamanTutorial extends StatelessWidget {
  const HalamanTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tutorials = [
      {
        'videoId': 'qS1IfnVLNJ8',
        'title': 'Prosedur Aman Penggunaan APAR',
      },
      {
        'videoId': 'abc123xyz00',
        'title': 'Cara Evakuasi Korban Kebakaran',
      },
      {
        'videoId': 'def456ghi11',
        'title': 'Langkah Pertolongan Pertama pada Luka Bakar',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Semua Tutorial")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tutorials.length,
        itemBuilder: (context, index) {
          final item = tutorials[index];
          return TutorialItem(
            videoId: item['videoId']!,
            title: item['title']!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TutorialVideoPage(
                    videoId: item['videoId']!,
                    title: item['title']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TutorialItem extends StatelessWidget {
  final String videoId;
  final String title;
  final VoidCallback onTap;

  const TutorialItem({
    super.key,
    required this.videoId,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                height: 180,
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
}
