
class Book {
  final String id;
  final String title;
  final String? subtitle;
  final List<String> authors;
  final String? publisher;
  final int? year;
  final String? isbn;
  final List<String> categories;

  Book({
    required this.id,
    required this.title,
    this.subtitle,
    required this.authors,
    this.publisher,
    this.year,
    this.isbn,
    required this.categories,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['i']?.toString() ?? '',
      title: json['t']?.toString() ?? '',
      subtitle: json['s']?.toString(),

      authors: (json['a'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],

      publisher: json['p']?.toString(),
      year: json['y'] as int?,
      isbn: json['b']?.toString(),

      categories: (json['c'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }

  String get authorText {
    return authors.isEmpty ? 'Penulis tidak diketahui' : authors.join(', ');
  }

  String get categoryText {
    return categories.isEmpty ? 'Lainnya' : categories.join(', ');
  }
}
