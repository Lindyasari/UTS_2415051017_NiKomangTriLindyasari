
import 'package:flutter/material.dart';

import '../models/saved_book_model.dart';
import '../repositories/saved_book_repository.dart';

class SavedBookProvider extends ChangeNotifier {
  final SavedBookRepository repository;

  SavedBookProvider({
    required this.repository,
  });

  List<SavedBook> _savedBooks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SavedBook> get savedBooks => _savedBooks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Mengambil daftar koleksi buku.
  Future<void> fetchSavedBooks() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final books = await repository.getSavedBooks();
      _savedBooks = books;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error fetchSavedBooks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Menambahkan buku ke koleksi.
  Future<bool> addSavedBook(SavedBook book) async {
    try {
      await repository.addSavedBook(book);
      await fetchSavedBooks();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error addSavedBook: $e');
      notifyListeners();
      return false;
    }
  }

  // Memperbarui data buku.
  Future<bool> updateSavedBook(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      await repository.updateSavedBook(id, data);
      await fetchSavedBooks();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error updateSavedBook: $e');
      notifyListeners();
      return false;
    }
  }

  // Menghapus buku dari koleksi.
  Future<bool> deleteSavedBook(String id) async {
    try {
      await repository.deleteSavedBook(id);
      await fetchSavedBooks();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error deleteSavedBook: $e');
      notifyListeners();
      return false;
    }
  }
}
