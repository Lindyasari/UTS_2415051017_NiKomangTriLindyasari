
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/saved_book_model.dart';

class SavedBookRepository {
  final SupabaseClient supabase;

  SavedBookRepository({
    required this.supabase,
  });

  // Mengambil semua buku milik pengguna yang sedang aktif.
  Future<List<SavedBook>> getSavedBooks() async {
    try {
      final response = await supabase
          .from('saved_books')
          .select()
          .order('created_at', ascending: false);

      return response
          .map((item) => SavedBook.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil koleksi buku: $e');
    }
  }

  // Menambahkan buku ke koleksi tanpa duplikasi.
  Future<void> addSavedBook(SavedBook book) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum terautentikasi.');
    }

    try {
      // Periksa apakah buku sudah tersimpan.
      final existing = await supabase
          .from('saved_books')
          .select('id')
          .eq('user_id', user.id)
          .eq('book_key', book.bookKey)
          .maybeSingle();

      if (existing != null) {
        throw Exception('Buku sudah ada di koleksi kamu.');
      }

      final data = book.toJson();
      data['user_id'] = user.id;

      await supabase.from('saved_books').insert(data);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw Exception('Buku sudah ada di koleksi kamu.');
      }
      throw Exception('Gagal menambahkan buku: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  // Mengubah data buku.
  Future<void> updateSavedBook(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      await supabase
          .from('saved_books')
          .update(data)
          .eq('id', id);
    } catch (e) {
      throw Exception('Gagal memperbarui buku: $e');
    }
  }

  // Menghapus buku dari koleksi.
  Future<void> deleteSavedBook(String id) async {
    try {
      await supabase
          .from('saved_books')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus buku: $e');
    }
  }
}
