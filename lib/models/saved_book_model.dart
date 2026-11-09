class SavedBook {
  final String? id;
  final String bookKey;
  final String title;
  final String? author;
  final String? coverUrl;
  final String readingStatus;
  final int? rating;
  final String? note;
  final String? userId;

  SavedBook({
    this.id,
    required this.bookKey,
    required this.title,
    this.author,
    this.coverUrl,
    this.readingStatus = 'Belum Dibaca',
    this.rating,
    this.note,
    this.userId,
  });

  factory SavedBook.fromJson(Map<String, dynamic> json) {
    return SavedBook(
      id: json['id']?.toString(),
      bookKey: json['book_key']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      author: json['author']?.toString(),
      coverUrl: json['cover_url']?.toString(),
      readingStatus:
          json['reading_status']?.toString() ?? 'Belum Dibaca',
      rating: json['rating'] as int?,
      note: json['note']?.toString(),
      userId: json['user_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book_key': bookKey,
      'title': title,
      'author': author,
      'cover_url': coverUrl,
      'reading_status': readingStatus,
      'rating': rating,
      'note': note,
      'user_id': userId,
    };
  }
}