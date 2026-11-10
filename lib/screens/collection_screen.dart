
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/saved_book_model.dart';
import '../providers/saved_book_provider.dart';
import 'book_detail_screen.dart';

class CollectionScreen extends StatefulWidget {
  final String initialFilter;

  const CollectionScreen({
    super.key,
    this.initialFilter = 'Semua',
  });

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  late String _selectedFilter;

  final List<String> _filters = [
    'Semua',
    'Belum Dibaca',
    'Sedang Dibaca',
    'Selesai Dibaca',
  ];

  @override
  void initState() {
    super.initState();

    // Mengambil filter awal dari HomeScreen.
    _selectedFilter = widget.initialFilter;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SavedBookProvider>().fetchSavedBooks();
      }
    });
  }

  // Memperbarui filter ketika halaman menerima filter baru.
  @override
  void didUpdateWidget(covariant CollectionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialFilter != widget.initialFilter) {
      setState(() {
        _selectedFilter = widget.initialFilter;
      });
    }
  }

  Future<void> _refreshCollection() async {
    await context.read<SavedBookProvider>().fetchSavedBooks();
  }

  // FILTER BUKU BERDASARKAN STATUS
  List<SavedBook> _getFilteredBooks(List<SavedBook> books) {
    if (_selectedFilter == 'Semua') {
      return books;
    }

    return books
        .where((book) => book.readingStatus == _selectedFilter)
        .toList();
  }

  // KONFIRMASI HAPUS BUKU
  Future<void> _confirmDelete(SavedBook book) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F7F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Hapus Buku?',
            style: TextStyle(
              color: Color(0xFF315C49),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus '
            '"${book.title}" dari koleksi?',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Color(0xFF477A65),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    await _deleteBook(book);
  }

  // PROSES HAPUS BUKU
  Future<void> _deleteBook(SavedBook book) async {
    if (book.id == null) return;

    final provider = context.read<SavedBookProvider>();

    final success = await provider.deleteSavedBook(book.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Buku berhasil dihapus dari koleksi.'
              : 'Gagal menghapus buku. Silakan coba lagi.',
        ),
        backgroundColor:
            success ? const Color(0xFF477A65) : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7F3),
        elevation: 0,
        title: const Text(
          'Koleksi Saya',
          style: TextStyle(
            color: Color(0xFF315C49),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _refreshCollection,
            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF477A65),
            ),
            tooltip: 'Muat ulang koleksi',
          ),
        ],
      ),
      body: Consumer<SavedBookProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.savedBooks.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF477A65),
              ),
            );
          }

          if (provider.errorMessage != null &&
              provider.savedBooks.isEmpty) {
            return _buildErrorState(provider.errorMessage!);
          }

          if (provider.savedBooks.isEmpty) {
            return _buildEmptyState();
          }

          final filteredBooks =
              _getFilteredBooks(provider.savedBooks);

          return RefreshIndicator(
            onRefresh: _refreshCollection,
            color: const Color(0xFF477A65),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildCollectionHeader(provider.savedBooks.length),
                const SizedBox(height: 18),
                _buildFilter(),
                const SizedBox(height: 16),
                Text(
                  '${filteredBooks.length} buku ditemukan',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF315C49),
                  ),
                ),
                const SizedBox(height: 14),
                if (filteredBooks.isEmpty)
                  _buildFilterEmptyState()
                else
                  ...filteredBooks.map(
                    (book) => _buildBookCard(book),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // FILTER STATUS BACA
  Widget _buildFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: const Color(0xFF477A65),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF315C49),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFF477A65)
                    : const Color(0xFFE0E5DF),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  // HEADER KOLEKSI
  Widget _buildCollectionHeader(int totalBooks) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3EEE6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Koleksi Bacaanmu',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF315C49),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Semua buku yang kamu simpan ada di sini.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.menu_book_rounded,
                color: Color(0xFF477A65),
              ),
              const SizedBox(width: 8),
              Text(
                '$totalBooks buku tersimpan',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF315C49),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // KARTU BUKU
  Widget _buildBookCard(SavedBook book) {
    final hasNote =
        book.note != null && book.note!.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SavedBookDetailScreen(
                  savedBook: book,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE8E8E2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 65,
                  height: 85,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3EEE6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 34,
                    color: Color(0xFF477A65),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF315C49),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        book.author ?? 'Penulis tidak diketahui',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3EEE6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          book.readingStatus,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF315C49),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFE5A72B),
                            size: 19,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            book.rating == null
                                ? 'Belum diberi rating'
                                : '${book.rating}/5',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF315C49),
                            ),
                          ),
                        ],
                      ),
                      if (hasNote) ...[
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.notes_rounded,
                              size: 16,
                              color: Color(0xFF477A65),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                book.note!.trim(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  children: [
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF477A65),
                    ),
                    const SizedBox(height: 12),
                    IconButton(
                      onPressed: () => _confirmDelete(book),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                        size: 22,
                      ),
                      tooltip: 'Hapus buku',
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // EMPTY STATE JIKA FILTER TIDAK MENEMUKAN BUKU
  Widget _buildFilterEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 45,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.filter_list_off_rounded,
            size: 48,
            color: Color(0xFF9AA99F),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tidak Ada Buku',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF315C49),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Belum ada buku dengan status "$_selectedFilter".',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // EMPTY STATE KOLEKSI
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Color(0xFFE3EEE6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_border_rounded,
                size: 55,
                color: Color(0xFF477A65),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Koleksimu Masih Kosong',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF315C49),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Yuk, jelajahi katalog dan tambahkan buku '
              'favoritmu ke koleksi!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ERROR STATE
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 55,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Koleksi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF315C49),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _refreshCollection,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF477A65),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
