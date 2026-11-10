import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book_model.dart';

class BookApiService {
  static const String apiRoot =
      'https://khrlanamm.github.io/buku-indonesia/api/v1';

  static const String baseUrl = '$apiRoot/search-index.json';

  static const int maxBooksWithCover = 30;

  Future<List<Book>> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode != 200) {
        throw Exception('Gagal mengambil data buku: ${response.statusCode}');
      }

      final decodedData = jsonDecode(response.body);

      final List<dynamic> bookData;

      if (decodedData is List) {
        bookData = decodedData;
      } else if (decodedData is Map<String, dynamic>) {
        bookData = decodedData['books'] ?? decodedData['data'] ?? [];
      } else {
        throw Exception('Format data API tidak sesuai');
      }

      final books = bookData
          .map((json) => Book.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      // Ambil detail dan cover untuk maksimal 30 buku.
      final booksWithCovers = await Future.wait(
        books.take(maxBooksWithCover).map((book) => _fetchBookDetail(book)),
      );

      // Buku lainnya tetap dipertahankan.
      return [...booksWithCovers, ...books.skip(maxBooksWithCover)];
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<Book> _fetchBookDetail(Book book) async {
    try {
      final url = Uri.parse(
        '$apiRoot/books/${Uri.encodeComponent(book.id)}.json',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final detailData = jsonDecode(response.body);

        if (detailData is Map<String, dynamic>) {
          return Book.fromJson(detailData);
        }
      }
    } catch (_) {
      // Jika detail gagal diambil, gunakan data buku awal.
    }

    return book;
  }
}
