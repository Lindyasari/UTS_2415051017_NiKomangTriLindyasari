import 'package:flutter/material.dart';
import 'lesson_plan_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0D4FF),
        elevation: 0,
        title: const Text(
          'EduSpark', // Kata "Dashboard" dihapus agar lebih bersih
          style: TextStyle(
            fontSize: 28, // Ukuran diperbesar bak sebuah logo
            fontWeight: FontWeight.w900, // Ketebalan ekstra tebal
            letterSpacing: 1.5, // Jarak antar huruf agar lebih elegan
            color: Color(0xFF4A148C), // Warna ungu tua pekat agar kontras dan tajam
            fontFamily: 'serif', // Jenis font berbeda dari teks biasa (klasik/elegan)
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 32, top: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFE0D4FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang, Lindya!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mari kelola rencana materi ajar hari ini dengan terstruktur.',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      _buildStatCard(title: 'Total', count: '8', icon: Icons.library_books, color: const Color(0xFF6C63FF)),
                      const SizedBox(width: 12),
                      _buildStatCard(title: 'Aktif', count: '2', icon: Icons.trending_up, color: Colors.orange),
                      const SizedBox(width: 12),
                      _buildStatCard(title: 'Selesai', count: '4', icon: Icons.check_circle, color: Colors.teal),
                    ],
                  ),
                ],
              ),
            ),
            
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Akses Cepat Menu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  _buildMenuCard(
                    context,
                    title: 'Katalog Materi Ajar',
                    subtitle: 'Lihat daftar rencana pembelajaran (RPP)',
                    icon: Icons.school_rounded,
                    color: const Color(0xFF6C63FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LessonPlanListScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuCard(
                    context,
                    title: 'Panduan EduSpark',
                    subtitle: 'Info pengembangan sistem terpadu',
                    icon: Icons.info_outline_rounded,
                    color: const Color(0xFF6C63FF),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sistem Manajemen Pembelajaran EduSpark')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Expanded _buildStatCard({required String title, required String count, required IconData icon, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 28, color: color),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      ),
    );
  }
}