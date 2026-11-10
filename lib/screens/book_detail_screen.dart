import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book_model.dart';
import '../models/saved_book_model.dart';
import '../providers/saved_book_provider.dart';

// =====================================================
// DETAIL BUKU DARI KATALOG
// =====================================================

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool _isAdding = false;

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
      coverUrl: widget.book.coverUrl,
      readingStatus: 'Belum Dibaca',
    );

    final success = await provider.addSavedBook(savedBook);

    if (!mounted) return;

    final errorMessage = provider.errorMessage ?? '';

    final isDuplicate = errorMessage.contains('Buku sudah ada di koleksi kamu');

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        iconTheme: const IconThemeData(color: Color(0xFF315C49)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildBookCover(book.coverUrl)),

            const SizedBox(height: 24),

            Text(
              book.title,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF315C49),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Oleh ${book.authorText}',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 24),

            const Text(
              'Informasi Buku',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            _infoItem('Kategori', book.categoryText),
            _infoItem('Penerbit', book.publisher ?? 'Tidak tersedia'),
            _infoItem(
              'Tahun Terbit',
              book.year?.toString() ?? 'Tidak tersedia',
            ),
            _infoItem('ISBN', book.isbn ?? 'Tidak tersedia'),

            const SizedBox(height: 24),

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
                  _isAdding ? 'Menambahkan...' : 'Tambahkan ke Koleksi',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF477A65),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF477A65)
                      .withValues(alpha: 0.7),
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

  Widget _buildBookCover(String? coverUrl) {
    return Container(
      width: 180,
      height: 230,
      decoration: BoxDecoration(
        color: const Color(0xFFE3EEE6),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: coverUrl != null && coverUrl.isNotEmpty
          ? Image.network(
              coverUrl,
              width: 180,
              height: 230,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _coverPlaceholder();
              },
            )
          : _coverPlaceholder(),
    );
  }

  Widget _coverPlaceholder() {
    return const Center(
      child: Icon(Icons.menu_book_rounded, size: 85, color: Color(0xFF477A65)),
    );
  }

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
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// DETAIL BUKU DARI KOLEKSI
// =====================================================

class SavedBookDetailScreen extends StatefulWidget {
  final SavedBook savedBook;

  const SavedBookDetailScreen({super.key, required this.savedBook});

  @override
  State<SavedBookDetailScreen> createState() => _SavedBookDetailScreenState();
}

class _SavedBookDetailScreenState extends State<SavedBookDetailScreen> {
  late String _selectedStatus;
  late TextEditingController _noteController;

  late String _originalStatus;
  late int? _originalRating;
  late String _originalNote;

  int? _selectedRating;

  bool _isSaving = false;

  final List<String> _readingStatuses = [
    'Belum Dibaca',
    'Sedang Dibaca',
    'Selesai Dibaca',
  ];

  @override
  void initState() {
    super.initState();

    final book = widget.savedBook;

    _selectedStatus = book.readingStatus;
    _selectedRating = book.rating;

    _noteController = TextEditingController(text: book.note ?? '');

    _originalStatus = book.readingStatus;
    _originalRating = book.rating;
    _originalNote = book.note ?? '';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // Menyimpan status, rating, dan catatan ke Supabase.
  Future<void> _saveDetails() async {
    if (_isSaving) return;

    final bookId = widget.savedBook.id;

    if (bookId == null) {
      _showMessage('ID buku tidak ditemukan.', Colors.red.shade700);
      return;
    }

    final currentNote = _noteController.text.trim();

    final hasChanges =
        _selectedStatus != _originalStatus ||
        _selectedRating != _originalRating ||
        currentNote != _originalNote;

    if (!hasChanges) {
      _showMessage(
        'Belum ada perubahan yang perlu disimpan.',
        Colors.orange.shade700,
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final provider = context.read<SavedBookProvider>();

    final success = await provider.updateSavedBook(bookId, {
      'reading_status': _selectedStatus,
      'rating': _selectedRating,
      'note': currentNote.isEmpty ? null : currentNote,
    });

    if (!mounted) return;

    setState(() {
      _isSaving = false;

      if (success) {
        _originalStatus = _selectedStatus;
        _originalRating = _selectedRating;
        _originalNote = currentNote;
      }
    });

    _showMessage(
      success
          ? 'Detail buku berhasil diperbarui!'
          : 'Gagal menyimpan perubahan. Silakan coba lagi.',
      success ? const Color(0xFF477A65) : Colors.red.shade700,
    );
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.savedBook;

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
        iconTheme: const IconThemeData(color: Color(0xFF315C49)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // COVER BUKU
            Center(child: _buildBookCover(book.coverUrl)),

            const SizedBox(height: 24),

            // JUDUL DAN PENULIS
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF315C49),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Oleh ${book.author ?? 'Penulis tidak diketahui'}',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 24),

            const Text(
              'Informasi Buku',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            _infoItem('Status Baca', _selectedStatus),

            _infoItem(
              'Rating',
              _selectedRating == null
                  ? 'Belum diberi rating'
                  : '$_selectedRating/5',
            ),

            _infoItem(
              'Catatan',
              _noteController.text.trim().isEmpty
                  ? 'Belum ada catatan'
                  : _noteController.text.trim(),
            ),

            const SizedBox(height: 24),

            // UBAH STATUS BACA
            const Text(
              'Ubah Status Baca',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF315C49),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E5DF)),
                ),
              ),
              items: _readingStatuses.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: _isSaving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      }
                    },
            ),

            const SizedBox(height: 24),

            // RATING BUKU
            const Text(
              'Berikan Rating Buku',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF315C49),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Bagaimana pendapatmu tentang buku ini?',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),

            const SizedBox(height: 10),

            Row(
              children: List.generate(5, (index) {
                final ratingValue = index + 1;
                final isSelected =
                    _selectedRating != null && ratingValue <= _selectedRating!;

                return IconButton(
                  onPressed: _isSaving
                      ? null
                      : () {
                          setState(() {
                            _selectedRating = ratingValue;
                          });
                        },
                  icon: Icon(
                    isSelected
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: const Color(0xFFE5A72B),
                    size: 34,
                  ),
                  tooltip: '$ratingValue bintang',
                );
              }),
            ),

            if (_selectedRating != null)
              Row(
                children: [
                  Text(
                    '$_selectedRating dari 5 bintang',
                    style: const TextStyle(
                      color: Color(0xFF477A65),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _isSaving
                        ? null
                        : () {
                            setState(() {
                              _selectedRating = null;
                            });
                          },
                    child: const Text(
                      'Hapus rating',
                      style: TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // CATATAN PRIBADI
            const Text(
              'Catatan Pribadi',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF315C49),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Tuliskan kesan atau hal menarik dari buku ini.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _noteController,
              enabled: !_isSaving,
              maxLines: 4,
              maxLength: 500,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Tulis catatanmu di sini...',
                filled: true,
                fillColor: Colors.white,
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E5DF)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF477A65),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // TOMBOL SIMPAN SEMUA PERUBAHAN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveDetails,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_rounded),
                label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Perubahan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF477A65),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF477A65)
                      .withValues(alpha: 0.7),
                  disabledForegroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // INFORMASI KOLEKSI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE3EEE6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Buku ini tersimpan di koleksi pribadimu.',
                style: TextStyle(fontSize: 13, color: Color(0xFF315C49)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCover(String? coverUrl) {
    return Container(
      width: 180,
      height: 230,
      decoration: BoxDecoration(
        color: const Color(0xFFE3EEE6),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: coverUrl != null && coverUrl.isNotEmpty
          ? Image.network(
              coverUrl,
              width: 180,
              height: 230,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _coverPlaceholder();
              },
            )
          : _coverPlaceholder(),
    );
  }

  Widget _coverPlaceholder() {
    return const Center(
      child: Icon(Icons.menu_book_rounded, size: 85, color: Color(0xFF477A65)),
    );
  }

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
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
