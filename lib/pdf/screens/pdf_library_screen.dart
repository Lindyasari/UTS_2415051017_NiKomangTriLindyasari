
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pdf_book_model.dart';
import '../providers/pdf_library_provider.dart';
import 'pdf_detail_screen.dart';

class PdfLibraryScreen extends StatefulWidget {
  const PdfLibraryScreen({super.key});

  @override
  State<PdfLibraryScreen> createState() => _PdfLibraryScreenState();
}

class _PdfLibraryScreenState extends State<PdfLibraryScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<PdfLibraryProvider>().fetchPdfBooks();
    });
  }

  Future<void> _importPdf() async {
    final provider = context.read<PdfLibraryProvider>();

    final success = await provider.importPdf();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF berhasil ditambahkan ke perpustakaan!'),
          backgroundColor: Color(0xFF477A65),
        ),
      );
    } else if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal mengimpor PDF: ${provider.errorMessage}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // Membuka halaman detail PDF.
  void _openPdfDetail(PdfBook book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfDetailScreen(
          pdfBook: book,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perpustakaan PDF',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF8F7F3),
      ),
      body: Consumer<PdfLibraryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF477A65),
              ),
            );
          }

          if (provider.errorMessage != null &&
              provider.pdfBooks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gagal memuat perpustakaan PDF',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: provider.fetchPdfBooks,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.pdfBooks.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: provider.fetchPdfBooks,
            color: const Color(0xFF477A65),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHeader(provider.pdfBooks.length),
                const SizedBox(height: 20),
                ...provider.pdfBooks.map(
                  (book) => _buildPdfCard(book),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _importPdf,
        backgroundColor: const Color(0xFF477A65),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.upload_file),
        label: const Text('Import PDF'),
      ),
    );
  }

  // Header perpustakaan PDF.
  Widget _buildHeader(int total) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EFE9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.picture_as_pdf,
            size: 40,
            color: Color(0xFF477A65),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Koleksi PDF Saya',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('$total dokumen tersimpan'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tampilan ketika belum ada PDF.
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.picture_as_pdf_outlined,
              size: 85,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada PDF',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan dokumen PDF dari perangkatmu '
              'untuk mulai membangun perpustakaan digital.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Kartu PDF dengan informasi penerbit dan rating.
  Widget _buildPdfCard(PdfBook book) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFFFCE8E6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.picture_as_pdf,
            color: Colors.redAccent,
            size: 30,
          ),
        ),
        title: Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nama penerbit.
              if (book.publisher != null &&
                  book.publisher!.trim().isNotEmpty)
                Text(
                  'Penerbit: ${book.publisher}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),

              // Rating buku.
              if (book.rating != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${book.rating}/5',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 4),

              // Ukuran, tanggal, dan progres membaca.
              Text(
                '${_formatFileSize(book.fileSize)} • '
                '${_formatDate(book.addedAt)}\n'
                'Halaman terakhir: ${book.lastReadPage}',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFF477A65),
        ),
        onTap: () => _openPdfDetail(book),
      ),
    );
  }
}
