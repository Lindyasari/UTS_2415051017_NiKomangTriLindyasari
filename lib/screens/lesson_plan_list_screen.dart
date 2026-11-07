import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lesson_plan_provider.dart';

class LessonPlanListScreen extends StatefulWidget {
  const LessonPlanListScreen({super.key});

  @override
  State<LessonPlanListScreen> createState() => _LessonPlanListScreenState();
}

class _LessonPlanListScreenState extends State<LessonPlanListScreen> {
  @override
  void initState() {
    super.initState();
    // Memanggil data dari Supabase begitu halaman ini dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LessonPlanProvider>(context, listen: false).fetchLessonPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Materi EduSpark'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<LessonPlanProvider>(
        builder: (context, provider, child) {
          // 1. STATE LOADING (Menampilkan indikator berputar saat memuat data)
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. STATE ERROR (Menampilkan pesan jika gagal koneksi/database)
          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  provider.errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // 3. STATE EMPTY (Jika data dari Supabase masih kosong)
          if (provider.lessonPlans.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data materi.\nSilakan tambahkan data baru!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // 4. STATE DATA (Menampilkan data ke ListView yang responsif)
          return ListView.builder(
            itemCount: provider.lessonPlans.length,
            itemBuilder: (context, index) {
              final plan = provider.lessonPlans[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    plan['title'] ?? 'Tanpa Judul',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(plan['description'] ?? 'Tanpa Deskripsi'),
                  trailing: Chip(
                    label: Text(plan['category'] ?? 'Umum'),
                    backgroundColor: Colors.blue.shade50,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}