import 'package:url_launcher/url_launcher.dart';

void launchWhatsApp() async {
    final String phone =
        '6285645957236';
    final String message = Uri.encodeComponent('''
📢 LAPORAN KEBAKARAN / DARURAT
Mohon bantuan segera 🙏

📌 Data Pelapor:
- Nama: 
- No. Telepon: 

📍 Lokasi Kejadian:
- Alamat Lengkap: 
- Titik Lokasi (Opsional): 

🔥 Jenis Kejadian:
- [ ] Kebakaran rumah
- [ ] Kebakaran hutan/lahan
- [ ] Korsleting listrik
- [ ] Kecelakaan lalu lintas
- [ ] Hewan berbahaya (ular, tawon, dll)
- [ ] Lainnya: 

🕒 Waktu Kejadian:
- 

📷 Dokumentasi (opsional):
- 
    ''');

    final url = 'https://wa.me/$phone?text=$message';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }