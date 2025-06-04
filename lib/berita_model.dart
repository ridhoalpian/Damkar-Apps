import 'package:damkarapps/file_tambahan/apiutils.dart';

class Berita {
  final String judul;
  final String penulis;
  final String isi;
  final String foto;

  Berita({required this.judul, required this.penulis, required this.isi, required this.foto});

  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
      judul: json['judul'],
      penulis: json['penulis'],
      isi: json['isi'],
      foto: ApiUtils.buildUrl('/storage/'+json['foto']),
    );
  }
}
