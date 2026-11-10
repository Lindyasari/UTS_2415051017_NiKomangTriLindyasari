import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pdf_book_model.dart';
import '../providers/pdf_library_provider.dart';
import 'pdf_reader_screen.dart';

class PdfDetailScreen extends StatefulWidget {
  final PdfBook pdfBook;

  const PdfDetailScreen({super.key, required this.pdfBook});

  @override
  State<PdfDetailScreen> createState() => _PdfDetailScreenState();
}

class _PdfDetailScreenState extends State<PdfDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _authorController;
  late final TextEditingController _publisherController;
  late final TextEditingController _noteController;

  late bool _isFavorite;
  late String _readingStatus;
  int? _rating;

  bool _isSaving = false;

  final List<String> _readingStatuses = [
    'Belum Dibaca',
    'Sedang Dibaca',
    'Selesai Dibaca',
  ];

  @override
  void initState() {
    super.initState();

    _authorController = TextEditingController(
      text: widget.pdfBook.author ?? '',
    );

    _publisherController = TextEditingController(
      text: widget.pdfBook.publisher ?? '',
    );

    _noteController = TextEditingController(text: widget.pdfBook.note ?? '');

    _isFavorite = widget.pdfBook.isFavorite;
    _readingStatus = widget.pdfBook.readingStatus;
    _rating = widget.pdfBook.rating;
  }

  @override
  void dispose() {
    _authorController.dispose();
    _publisherController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final updatedBook = widget.pdfBook.copyWith(
      author: _authorController.text.trim().isEmpty
          ? null
          : _authorController.text.trim(),
      publisher: _publisherController.text.trim().isEmpty
          ? null
          : _publisherController.text.trim(),
      isFavorite: _isFavorite,
      readingStatus: _readingStatus,
      rating: _rating,
      clearRating: _rating == null,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      clearNote: _noteController.text.trim().isEmpty,
    );

    final success = await context.read<PdfLibraryProvider>().updatePdf(
      updatedBook,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Informasi PDF berhasil disimpan.'
              : 'Gagal menyimpan informasi PDF.',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      Navigator.pop(context);
    }
  }

  void _openPdfReader() {
    final provider = context.read<PdfLibraryProvider>();

    // Ambil data PDF terbaru dari provider.
    final latestBook = provider.pdfBooks.firstWhere(
      (book) => book.id == widget.pdfBook.id,
      orElse: () => widget.pdfBook,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfReaderScreen(pdfBook: latestBook),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F3),
      appBar: AppBar(
        title: const Text('Detail PDF'),
        backgroundColor: const Color(0xFFF8F7F3),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informasi utama PDF.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.picture_as_pdf_rounded,
                      size: 64,
                      color: Color(0xFF477A65),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.pdfBook.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ukuran file: ${_formatFileSize(widget.pdfBook.fileSize)}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _openPdfReader,
                        icon: const Icon(Icons.menu_book),
                        label: const Text('Baca PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF477A65),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Informasi buku.
              const Text(
                'Informasi Buku',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _authorController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama penulis tidak boleh kosong';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Nama Penulis',
                  hintText: 'Masukkan nama penulis',
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _publisherController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Penerbit tidak boleh kosong';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Penerbit',
                  hintText: 'Masukkan nama penerbit',
                  prefixIcon: const Icon(Icons.business_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Pengaturan membaca.
              const Text(
                'Pengaturan Membaca',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  title: const Text('Buku Favorit'),
                  subtitle: const Text('Tambahkan PDF ke daftar favorit'),
                  secondary: const Icon(
                    Icons.favorite_outline,
                    color: Color(0xFF477A65),
                  ),
                  value: _isFavorite,
                  activeTrackColor: const Color(0xFF477A65),
                  onChanged: (value) {
                    setState(() {
                      _isFavorite = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _readingStatus,
                decoration: InputDecoration(
                  labelText: 'Status Membaca',
                  prefixIcon: const Icon(Icons.book_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _readingStatuses.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _readingStatus = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 24),

              // Rating buku.
              const Text(
                'Rating Buku',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Berikan penilaianmu'),
                    const SizedBox(height: 10),
                    Row(
                      children: List.generate(5, (index) {
                        final starValue = index + 1;

                        return IconButton(
                          onPressed: () {
                            setState(() {
                              _rating = starValue;
                            });
                          },
                          icon: Icon(
                            starValue <= (_rating ?? 0)
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                        );
                      }),
                    ),
                    Text(
                      _rating == null
                          ? 'Belum ada rating'
                          : '$_rating dari 5 bintang',
                      style: theme.textTheme.bodySmall,
                    ),
                    if (_rating != null)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _rating = null;
                          });
                        },
                        child: const Text('Hapus rating'),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Catatan pribadi.
              const Text(
                'Catatan Pribadi',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tuliskan catatan tentang buku ini...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Tombol simpan.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveChanges,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Perubahan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF477A65),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
