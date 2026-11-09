
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/pdf_book_model.dart';

class PdfLibraryRepository {
  static const String _storageKey = 'bacayuk_pdf_library';

  final Uuid _uuid = const Uuid();

  // Mengambil lokasi folder penyimpanan internal aplikasi.
  Future<Directory> _getPdfDirectory() async {
    final appDirectory = await getApplicationDocumentsDirectory();

    final pdfDirectory = Directory(
      '${appDirectory.path}/pdf_library',
    );

    if (!await pdfDirectory.exists()) {
      await pdfDirectory.create(recursive: true);
    }

    return pdfDirectory;
  }

  // Mengambil daftar PDF yang tersimpan.
  Future<List<PdfBook>> getPdfBooks() async {
    final preferences = await SharedPreferences.getInstance();

    final jsonString = preferences.getString(_storageKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList
        .map(
          (json) => PdfBook.fromJson(
            Map<String, dynamic>.from(json),
          ),
        )
        .where((book) => File(book.filePath).existsSync())
        .toList();
  }

  // Menyimpan daftar PDF ke SharedPreferences.
  Future<void> _savePdfBooks(List<PdfBook> books) async {
    final preferences = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(
      books.map((book) => book.toJson()).toList(),
    );

    await preferences.setString(_storageKey, jsonString);
  }

  // Memilih dan mengimpor satu file PDF.
  Future<PdfBook?> importPdf() async {
    final selectedFile = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    // Pengguna membatalkan pemilihan file.
    if (selectedFile == null) {
      return null;
    }

    final originalPath = selectedFile.path;

    if (originalPath == null) {
      throw Exception('Lokasi file PDF tidak ditemukan.');
    }

    final originalFile = File(originalPath);

    if (!await originalFile.exists()) {
      throw Exception('File PDF tidak ditemukan.');
    }

    final pdfDirectory = await _getPdfDirectory();

    final id = _uuid.v4();

    final fileName =
        '${id}_${selectedFile.name.replaceAll(RegExp(r'[^\w.-]'), '_')}';

    final destinationPath = '${pdfDirectory.path}/$fileName';

    // Menyalin file ke penyimpanan internal aplikasi.
    final copiedFile = await originalFile.copy(destinationPath);

    final fileSize = await copiedFile.length();

    final pdfBook = PdfBook(
      id: id,
      title: selectedFile.name.replaceAll(
        RegExp(r'\.pdf$', caseSensitive: false),
        '',
      ),
      filePath: copiedFile.path,
      fileSize: fileSize,
      addedAt: DateTime.now(),
    );

    final books = await getPdfBooks();

    books.insert(0, pdfBook);

    await _savePdfBooks(books);

    return pdfBook;
  }

  // Memperbarui halaman terakhir yang dibaca.
  Future<void> updateReadingProgress(
    String id,
    int page,
  ) async {
    final books = await getPdfBooks();

    final index = books.indexWhere(
      (book) => book.id == id,
    );

    if (index == -1) return;

    books[index] = books[index].copyWith(
      lastReadPage: page,
    );

    await _savePdfBooks(books);
  }

  // Memperbarui informasi dan pengaturan PDF.
  Future<void> updatePdf(PdfBook updatedBook) async {
    final books = await getPdfBooks();

    final index = books.indexWhere(
      (book) => book.id == updatedBook.id,
    );

    if (index == -1) return;

    books[index] = updatedBook;

    await _savePdfBooks(books);
  }

  // Menghapus PDF dari perpustakaan.
  Future<void> deletePdf(String id) async {
    final books = await getPdfBooks();

    final index = books.indexWhere(
      (book) => book.id == id,
    );

    if (index == -1) return;

    final book = books[index];

    final file = File(book.filePath);

    if (await file.exists()) {
      await file.delete();
    }

    books.removeAt(index);

    await _savePdfBooks(books);
  }
}
