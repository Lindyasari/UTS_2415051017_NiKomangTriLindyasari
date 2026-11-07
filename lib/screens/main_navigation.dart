import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'lesson_plan_list_screen.dart';
import 'lesson_plan_add_screen.dart'; // Memanggil form tambah yang baru dibuat

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // 4 Halaman sesuai tab di bawah
  final List<Widget> _pages = [
    const HomeScreen(),
    const LessonPlanListScreen(),
    const Scaffold(body: Center(child: Text('Halaman Favorit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)))),
    const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 50, backgroundColor: Colors.deepPurple, child: Icon(Icons.person, size: 50, color: Colors.white)),
            SizedBox(height: 16),
            Text('Ni Komang Tri Lindyasari', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('2415051017 | Pendidikan Teknik Informatika', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      // Tombol Tambah Melayang di Tengah (Super Modern!)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LessonPlanAddScreen()),
          );
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // Bar Navigasi Bawah dengan lekukan di tengah
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.home_rounded, label: 'Home', index: 0),
              _buildNavItem(icon: Icons.menu_book_rounded, label: 'Materi', index: 1),
              const SizedBox(width: 48), // Spasi kosong untuk tombol FAB di tengah
              _buildNavItem(icon: Icons.favorite_border_rounded, label: 'Favorit', index: 2),
              _buildNavItem(icon: Icons.person_outline_rounded, label: 'Profil', index: 3),
            ],
          ),
        ),
      ),
    );
  }

  // Widget kustom untuk setiap item tab agar warnanya bisa berubah halus
  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.deepPurple : Colors.grey.shade400,
            size: isSelected ? 26 : 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.deepPurple : Colors.grey.shade400,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}