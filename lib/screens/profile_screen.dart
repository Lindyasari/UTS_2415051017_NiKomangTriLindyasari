
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/saved_book_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F3),
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF8F7F3),
        elevation: 0,
      ),
      body: Consumer<SavedBookProvider>(
        builder: (context, provider, child) {
          final books = provider.savedBooks;

          final totalBooks = books.length;
          final unreadBooks = books
              .where((book) => book.readingStatus == 'Belum Dibaca')
              .length;
          final readingBooks = books
              .where((book) => book.readingStatus == 'Sedang Dibaca')
              .length;
          final finishedBooks = books
              .where((book) => book.readingStatus == 'Selesai Dibaca')
              .length;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Identitas mahasiswa
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF477A65),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      backgroundImage: const AssetImage(
                        'assets/images/profile.jpg',
                      ),
                    ),
                    const SizedBox(height: 18),

                    const Text(
                      'Ni Komang Tri Lindyasari',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'NIM: 2415051017',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Pendidikan Teknik Informatika',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Universitas Pendidikan Ganesha',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Statistik koleksi
              const Text(
                'Statistik Koleksi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              _buildStatCard(
                icon: Icons.library_books,
                title: 'Total Buku',
                count: totalBooks,
                color: const Color(0xFF477A65),
              ),

              const SizedBox(height: 12),

              _buildStatCard(
                icon: Icons.book_outlined,
                title: 'Belum Dibaca',
                count: unreadBooks,
                color: Colors.orange,
              ),

              const SizedBox(height: 12),

              _buildStatCard(
                icon: Icons.menu_book,
                title: 'Sedang Dibaca',
                count: readingBooks,
                color: Colors.blue,
              ),

              const SizedBox(height: 12),

              _buildStatCard(
                icon: Icons.check_circle_outline,
                title: 'Selesai Dibaca',
                count: finishedBooks,
                color: Colors.green,
              ),

              const SizedBox(height: 28),

              // Tentang aplikasi
              const Text(
                'Tentang Aplikasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          color: Color(0xFF477A65),
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'BacaYuk',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    Text(
                      'BacaYuk merupakan aplikasi untuk membantu '
                      'pengguna mengelola koleksi buku, mencatat '
                      'progres membaca, serta memberikan rating '
                      'dan catatan pribadi pada buku.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Colors.black54,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      'Versi 1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
