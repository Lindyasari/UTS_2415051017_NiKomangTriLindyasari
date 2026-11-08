
import '../models/book_model.dart';
import '../services/book_api_service.dart';

class BookRepository {
  final BookApiService apiService;

  BookRepository({
    required this.apiService,
  });

  Future<List<Book>> getBooks() async {
    try {
      final books = await apiService.fetchBooks();
      return books;
    } catch (e) {
      throw Exception('Gagal memuat koleksi buku: $e');
    }
  }
}
