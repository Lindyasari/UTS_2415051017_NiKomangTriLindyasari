class MateriModel {
  final int id;
  final String title;
  final String category;
  final String targetGrade;
  final int durationMinutes;
  final String imageUrl;
  final String description;
  final List<String> learningObjectives;

  MateriModel({
    required this.id,
    required this.title,
    required this.category,
    required this.targetGrade,
    required this.durationMinutes,
    required this.imageUrl,
    required this.description,
    required this.learningObjectives,
  });

  factory MateriModel.fromJson(Map<String, dynamic> json) {
    return MateriModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      targetGrade: json['target_grade'],
      durationMinutes: json['duration_minutes'],
      imageUrl: json['image_url'],
      description: json['description'],
      // Karena learning_objectives di JSON bentuknya array, kita konversi ke List<String>
      learningObjectives: List<String>.from(json['learning_objectives'] ?? []),
    );
  }
}