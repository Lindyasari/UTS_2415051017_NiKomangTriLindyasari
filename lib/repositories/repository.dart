import '../services/database_service.dart';

class Repository {
  // Memanggil layanan database yang sudah kita buat sebelumnya
  final DatabaseService dbService = DatabaseService();

  // 1. CREATE (Meneruskan perintah tambah data)
  Future<void> insertLessonPlan(String title, String description, String category) async {
    await dbService.addLessonPlan(title, description, category);
  }

  // 2. READ (Meneruskan perintah ambil data)
  Future < List < Map < String, dynamic > > > getLessonPlans() async {
    return await dbService.fetchLessonPlans();
  }

  // 3. UPDATE (Meneruskan perintah ubah data)
  Future<void> editLessonPlan(int id, String title, String description, String category) async {
    await dbService.updateLessonPlan(id, title, description, category);
  }

  // 4. DELETE (Meneruskan perintah hapus data)
  Future<void> removeLessonPlan(int id) async {
    await dbService.deleteLessonPlan(id);
  }
}