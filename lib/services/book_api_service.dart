
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/book_model.dart';

class BookApiService {
  static const String baseUrl =
      'https://khrlanamm.github.io/buku-indonesia/api/v1/search-index.json';

  Future<List<Book>> fetchBooks() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        final List<dynamic> bookData;

        if (decodedData is List) {
          bookData = decodedData;
        } else if (decodedData is Map<String, dynamic>) {
          bookData = decodedData['books'] ??
              decodedData['data'] ??
              [];
        } else {
          throw Exception('Format data API tidak sesuai');
        }

        return bookData
            .map((json) => Book.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Gagal mengambil data buku: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
