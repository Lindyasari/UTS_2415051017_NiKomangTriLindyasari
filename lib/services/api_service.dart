import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/materi_model.dart';

class ApiService {
  // Ini adalah URL bersih dari GitHub Gist kamu kemarin
  static const String apiUrl = 'https://gist.githubusercontent.com/Lindyasari/783d21bd3fa7a031959380558e989117/raw/eduspark_materi.json';

  // Fungsi async untuk mengambil data (GET)
  Future<List<MateriModel>> fetchKatalogMateri() async {
    try {
      // Menjalankan request GET ke API
      final response = await http.get(Uri.parse(apiUrl));

      // Mengecek apakah request sukses (kode 200)
      if (response.statusCode == 200) {
        // Mengubah teks JSON menjadi bentuk List yang dipahami Dart
        List<dynamic> jsonList = jsonDecode(response.body);
        
        // Menerjemahkan setiap data JSON menjadi objek MateriModel
        return jsonList.map((json) => MateriModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data dari API. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}