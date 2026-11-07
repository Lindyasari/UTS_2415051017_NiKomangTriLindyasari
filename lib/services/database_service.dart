import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  // Memanggil koneksi Supabase yang sudah kita buka di main.dart
  final supabase = Supabase.instance.client;

  // 1. CREATE (Menambah data baru)
  Future<void> addLessonPlan(String title, String description, String category) async {
    await supabase.from('lesson_plans').insert({
      'title': title,
      'description': description,
      'category': category,
    });
  }

  // 2. READ (Mengambil semua data untuk ditampilkan)
  Future<List>> fetchLessonPlans() async {
    final data = await supabase.from('lesson_plans').select();
    return data;
  }

  // 3. UPDATE (Mengubah data yang sudah ada)
  Future<void> updateLessonPlan(int id, String title, String description, String category) async {
    await supabase.from('lesson_plans').update({
      'title': title,
      'description': description,
      'category': category,
    }).eq('id', id);
  }

  // 4. DELETE (Menghapus data)
  Future<void> deleteLessonPlan(int id) async {
    await supabase.from('lesson_plans').delete().eq('id', id);
  }
}