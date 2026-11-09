
import 'package:flutter/material.dart';

import '../models/pdf_book_model.dart';
import '../repositories/pdf_library_repository.dart';

class PdfLibraryProvider extends ChangeNotifier {
  final PdfLibraryRepository repository;

  PdfLibraryProvider({
    required this.repository,
  });

  List<PdfBook> _pdfBooks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PdfBook> get pdfBooks => _pdfBooks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Mengambil daftar PDF.
  Future<void> fetchPdfBooks() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pdfBooks = await repository.getPdfBooks();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error fetchPdfBooks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mengimpor PDF baru.
  Future<bool> importPdf() async {
    try {
      final pdfBook = await repository.importPdf();

      if (pdfBook == null) {
        return false;
      }

      _pdfBooks.insert(0, pdfBook);
      _errorMessage = null;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error importPdf: $e');
      notifyListeners();

      return false;
    }
  }

  // Memperbarui progres membaca.
  Future<bool> updateReadingProgress(
    String id,
    int page,
  ) async {
    try {
      await repository.updateReadingProgress(id, page);

      final index = _pdfBooks.indexWhere(
        (book) => book.id == id,
      );

      if (index != -1) {
        _pdfBooks[index] = _pdfBooks[index].copyWith(
          lastReadPage: page,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error updateReadingProgress: $e');
      notifyListeners();

      return false;
    }
  }

  // Memperbarui informasi PDF.
  Future<bool> updatePdf(PdfBook updatedBook) async {
    try {
      await repository.updatePdf(updatedBook);

      final index = _pdfBooks.indexWhere(
        (book) => book.id == updatedBook.id,
      );

      if (index != -1) {
        _pdfBooks[index] = updatedBook;
      }

      _errorMessage = null;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error updatePdf: $e');
      notifyListeners();

      return false;
    }
  }

  // Menghapus PDF dari perpustakaan.
  Future<bool> deletePdf(String id) async {
    try {
      await repository.deletePdf(id);

      _pdfBooks.removeWhere(
        (book) => book.id == id,
      );

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error deletePdf: $e');
      notifyListeners();

      return false;
    }
  }
}
