class Book {
  final String id;
  final String title;
  final String? subtitle;
  final List<String> authors;
  final String? publisher;
  final int? year;
  final String? isbn;
  final List<String> categories;
  final String? coverUrl;

  Book({
    required this.id,
    required this.title,
    this.subtitle,
    required this.authors,
    this.publisher,
    this.year,
    this.isbn,
    required this.categories,
    this.coverUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final authorData = json['authors'] ?? json['a'];
    final categoryData = json['categories'] ?? json['c'];

    return Book(
      id: (json['id'] ?? json['i'])?.toString() ?? '',
      title: (json['title'] ?? json['t'])?.toString() ?? '',
      subtitle: (json['subtitle'] ?? json['s'])?.toString(),

      authors:
          (authorData as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],

      publisher: (json['publisher'] ?? json['p'])?.toString(),
      year: (json['year'] ?? json['y']) as int?,
      isbn: (json['isbn13'] ?? json['isbn10'] ?? json['b'])?.toString(),

      categories:
          (categoryData as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],

      coverUrl: json['coverUrl']?.toString(),
    );
  }

  String get authorText {
    return authors.isEmpty ? 'Penulis tidak diketahui' : authors.join(', ');
  }

  String get categoryText {
    return categories.isEmpty ? 'Lainnya' : categories.join(', ');
  }
}
