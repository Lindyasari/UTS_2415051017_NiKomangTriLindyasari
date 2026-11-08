
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
  bool _hasFetched = false;
  String? _errorMessage;

  static const int maxBooks = 30;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBooks({bool forceRefresh = false}) async {
    // Hindari permintaan API berulang
    if (_isLoading) return;

    // Gunakan data yang sudah tersimpan
    if (_hasFetched && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final fetchedBooks = await repository.getBooks();

      _books = fetchedBooks.take(maxBooks).toList();

      _hasFetched = true;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
