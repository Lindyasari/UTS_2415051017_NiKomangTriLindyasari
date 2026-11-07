import 'package:flutter/material.dart';
import '../repositories/repository.dart';

class LessonPlanProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  // Spasi dilebarkan agar aman saat copy-paste
  List < Map < String, dynamic > > _lessonPlans = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Spasi dilebarkan agar aman saat copy-paste
  List < Map < String, dynamic > > get lessonPlans => _lessonPlans;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future < void > fetchLessonPlans() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); 

    try {
      _lessonPlans = await _repository.getLessonPlans();
    } catch (e) {
      _errorMessage = 'Gagal mengambil data: $e';
    } finally {
      _isLoading = false;
      notifyListeners(); 
    }
  }

  Future < bool > addLessonPlan(String title, String description, String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.insertLessonPlan(title, description, category);
      await fetchLessonPlans(); 
      return true; 
    } catch (e) {
      _errorMessage = 'Gagal menambah data: $e';
      _isLoading = false;
      notifyListeners();
      return false; 
    }
  }

  Future < bool > updateLessonPlan(int id, String title, String description, String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.editLessonPlan(id, title, description, category);
      await fetchLessonPlans(); 
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mengubah data: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future < bool > deleteLessonPlan(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.removeLessonPlan(id);
      await fetchLessonPlans(); 
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menghapus data: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}