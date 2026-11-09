
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book_model.dart';
import '../models/saved_book_model.dart';
import '../providers/saved_book_provider.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({
    super.key,
    required this.book,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool _isAdding = false;

  // Menambahkan buku ke koleksi pengguna.
  Future<void> _addToCollection() async {
    if (_isAdding) return;

    setState(() {
      _isAdding = true;
    });

    final provider = context.read<SavedBookProvider>();

    final savedBook = SavedBook(
      bookKey: widget.book.id,
      title: widget.book.title,
      author: widget.book.authorText,
      readingStatus: 'Belum Dibaca',
    );

    final success = await provider.addSavedBook(savedBook);

    if (!mounted) return;

    final errorMessage = provider.errorMessage ?? '';

    final isDuplicate = errorMessage.contains(
      'Buku sudah ada di koleksi kamu',
    );

    final message = success
        ? 'Buku berhasil ditambahkan ke koleksi!'
        : isDuplicate
            ? 'Buku ini sudah ada di koleksi kamu.'
            : 'Gagal menambahkan buku. Silakan coba lagi.';

    setState(() {
      _isAdding = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success
            ? const Color(0xFF477A65)
            : isDuplicate
                ? Colors.orange.shade700
                : Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7F3),
        elevation: 0,
        title: const Text(
          'Detail Buku',
          style: TextStyle(
            color: Color(0xFF315C49),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF315C49),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // COVER BUKU
            Center(
              child: Container(
                width: 180,
                height: 230,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3EEE6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 85,
                  color: Color(0xFF477A65),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // JUDUL BUKU
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF315C49),
              ),
            ),

            const SizedBox(height: 8),

            // PENULIS
            Text(
              'Oleh ${book.authorText}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 24),

            // INFORMASI BUKU
            const Text(
              'Informasi Buku',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            _infoItem('Kategori', book.categoryText),
            _infoItem(
              'Penerbit',
              book.publisher ?? 'Tidak tersedia',
            ),
            _infoItem(
              'Tahun Terbit',
              book.year?.toString() ?? 'Tidak tersedia',
            ),
            _infoItem(
              'ISBN',
              book.isbn ?? 'Tidak tersedia',
            ),

            const SizedBox(height: 24),

            // TOMBOL TAMBAH KE KOLEKSI
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isAdding ? null : _addToCollection,
                icon: _isAdding
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.bookmark_add_outlined),
                label: Text(
                  _isAdding
                      ? 'Menambahkan...'
                      : 'Tambahkan ke Koleksi',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF477A65),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      const Color(0xFF477A65).withValues(alpha: 0.7),
                  disabledForegroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan informasi buku.
  Widget _infoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
