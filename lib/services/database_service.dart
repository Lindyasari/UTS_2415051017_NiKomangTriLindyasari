import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final supabase = Supabase.instance.client;

  Future<void> addLessonPlan(String title, String description, String category) async {
    await supabase.from('lesson_plans').insert({
      'title': title,
      'description': description,
      'category': category,
    });
  }

  // Spasi dilebarkan agar aman saat di-copy paste
  Future < List < Map < String, dynamic > > > fetchLessonPlans() async {
    final data = await supabase.from('lesson_plans').select();
    return data;
  }

  Future<void> updateLessonPlan(int id, String title, String description, String category) async {
    await supabase.from('lesson_plans').update({
      'title': title,
      'description': description,
      'category': category,
    }).eq('id', id);
  }

  Future<void> deleteLessonPlan(int id) async {
    await supabase.from('lesson_plans').delete().eq('id', id);
  }
}