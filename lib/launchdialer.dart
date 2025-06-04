import 'package:url_launcher/url_launcher.dart';

void launchDialer() async {
    final Uri url = Uri(scheme: 'tel', path: '0331321213');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Tidak dapat membuka dialer.';
    }
  }