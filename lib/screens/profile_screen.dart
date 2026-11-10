
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/saved_book_provider.dart';
import 'collection_screen.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Ni Komang Tri Lindyasari';
  String _nim = '2415051017';
  String _program = 'Pendidikan Teknik Informatika';
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // MEMUAT DATA PROFIL
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _name = prefs.getString('profile_name') ??
          'Ni Komang Tri Lindyasari';
      _nim = prefs.getString('profile_nim') ?? '2415051017';
      _program = prefs.getString('profile_program') ??
          'Pendidikan Teknik Informatika';
      _profileImagePath = prefs.getString('profile_image');
    });
  }

  // MEMILIH DAN MENYIMPAN FOTO PROFIL
  Future<void> _pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      final pickedPath = image.path;
      final directory = await getApplicationDocumentsDirectory();

      final extension = pickedPath.contains('.')
          ? pickedPath.substring(pickedPath.lastIndexOf('.'))
          : '.jpg';

      final destination =
          '${directory.path}/profile_photo$extension';

      final savedFile = await File(pickedPath).copy(destination);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', savedFile.path);

      if (!mounted) return;

      setState(() {
        _profileImagePath = savedFile.path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto profil berhasil diperbarui.'),
          backgroundColor: Color(0xFF477A65),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengganti foto profil.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // EDIT IDENTITAS PROFIL
  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: _name);
    final nimController = TextEditingController(text: _nim);
    final programController = TextEditingController(text: _program);

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F7F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Edit Profil',
            style: TextStyle(
              color: Color(0xFF315C49),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEditField(
                  controller: nameController,
                  label: 'Nama Lengkap',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 14),
                _buildEditField(
                  controller: nimController,
                  label: 'NIM',
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 14),
                _buildEditField(
                  controller: programController,
                  label: 'Program Studi',
                  icon: Icons.school_outlined,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Batal',
                style: TextStyle(color: Color(0xFF477A65)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF477A65),
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final newName = nameController.text.trim();
      final newNim = nimController.text.trim();
      final newProgram = programController.text.trim();

      if (newName.isEmpty ||
          newNim.isEmpty ||
          newProgram.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Semua identitas harus diisi.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('profile_name', newName);
        await prefs.setString('profile_nim', newNim);
        await prefs.setString('profile_program', newProgram);

        if (!mounted) return;

        setState(() {
          _name = newName;
          _nim = newNim;
          _program = newProgram;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui.'),
            backgroundColor: Color(0xFF477A65),
          ),
        );
      }
    }

    nameController.dispose();
    nimController.dispose();
    programController.dispose();
  }

  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF477A65),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF477A65),
          ),
        ),
      ),
    );
  }

  // MEMBUKA KOLEKSI BERDASARKAN STATUS
  void _openCollection(String filter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CollectionScreen(
          initialFilter: filter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F3),
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: Color(0xFF315C49),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF8F7F3),
        elevation: 0,
      ),
      body: Consumer<SavedBookProvider>(
        builder: (context, provider, child) {
          final books = provider.savedBooks;

          final totalBooks = books.length;
          final unreadBooks = books
              .where((book) =>
                  book.readingStatus == 'Belum Dibaca')
              .length;
          final readingBooks = books
              .where((book) =>
                  book.readingStatus == 'Sedang Dibaca')
              .length;
          final finishedBooks = books
              .where((book) =>
                  book.readingStatus == 'Selesai Dibaca')
              .length;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // IDENTITAS PROFIL
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
                    GestureDetector(
                      onTap: _pickProfileImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                _profileImagePath != null
                                    ? FileImage(
                                        File(_profileImagePath!),
                                      )
                                    : const AssetImage(
                                        'assets/images/profile.jpg',
                                      ) as ImageProvider,
                            onBackgroundImageError:
                                (exception, stackTrace) {},
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF477A65),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Color(0xFF477A65),
                                size: 19,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      _name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
                      child: Text(
                        'NIM: $_nim',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _program,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: _editProfile,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit Profil'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // STATISTIK KOLEKSI
              const Text(
                'Statistik Koleksi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF315C49),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tekan statistik untuk melihat daftar buku.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 14),

              _buildStatCard(
                icon: Icons.library_books,
                title: 'Total Buku',
                count: totalBooks,
                color: const Color(0xFF477A65),
                filter: 'Semua',
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                icon: Icons.book_outlined,
                title: 'Belum Dibaca',
                count: unreadBooks,
                color: Colors.orange,
                filter: 'Belum Dibaca',
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                icon: Icons.menu_book,
                title: 'Sedang Dibaca',
                count: readingBooks,
                color: Colors.blue,
                filter: 'Sedang Dibaca',
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                icon: Icons.check_circle_outline,
                title: 'Selesai Dibaca',
                count: finishedBooks,
                color: Colors.green,
                filter: 'Selesai Dibaca',
              ),

              const SizedBox(height: 28),

              // TENTANG APLIKASI
              const Text(
                'Tentang Aplikasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF315C49),
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

  // KARTU STATISTIK YANG BISA DITEKAN
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required int count,
    required Color color,
    required String filter,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openCollection(filter),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE8E8E2),
            ),
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
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF477A65),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
