
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/saved_book_model.dart';
import '../providers/saved_book_provider.dart';
import 'book_detail_screen.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  void initState() {
    super.initState();

    // Mengambil koleksi buku dari Supabase.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SavedBookProvider>().fetchSavedBooks();
      }
    });
  }

  // Memuat ulang koleksi.
  Future<void> _refreshCollection() async {
    await context.read<SavedBookProvider>().fetchSavedBooks();
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
          // Loading state.
          if (provider.isLoading && provider.savedBooks.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF477A65),
              ),
            );
          }

          // Error state.
          if (provider.errorMessage != null &&
              provider.savedBooks.isEmpty) {
            return _buildErrorState(provider.errorMessage!);
          }

          // Empty state.
          if (provider.savedBooks.isEmpty) {
            return _buildEmptyState();
          }

          // Daftar buku.
          return RefreshIndicator(
            onRefresh: _refreshCollection,
            color: const Color(0xFF477A65),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildCollectionHeader(provider.savedBooks.length),
                const SizedBox(height: 20),

                ...provider.savedBooks.map(
                  (book) => _buildBookCard(book),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Header koleksi.
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

  // Kartu buku yang dapat diklik.
  Widget _buildBookCard(SavedBook book) {
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
                // Cover buku.
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

                // Informasi buku.
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
                    ],
                  ),
                ),

                const SizedBox(width: 5),

                // Ikon untuk menandakan kartu dapat dibuka.
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF477A65),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Tampilan ketika koleksi kosong.
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

  // Tampilan ketika terjadi kesalahan.
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
