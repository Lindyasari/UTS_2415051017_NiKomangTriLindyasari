
import 'package:flutter/material.dart';

import '../models/book_model.dart';
import '../repositories/book_repository.dart';

class BookProvider extends ChangeNotifier {
  final BookRepository repository;

  BookProvider({
    required this.repository,
  });

  List<Book> _books = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Maksimal buku yang ditampilkan
  static const int maxBooks = 30;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBooks() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      // Mengambil data buku dari API
      final fetchedBooks = await repository.getBooks();

      // Membatasi jumlah buku menjadi 30
      _books = fetchedBooks.take(maxBooks).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
