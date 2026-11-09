class PdfBook {
  final String id;
  final String title;
  final String filePath;
  final int fileSize;
  final DateTime addedAt;

  final String? author;
  final String? publisher;
  final bool isFavorite;
  final String readingStatus;
  final int? rating;
  final String? note;
  final int lastReadPage;

  const PdfBook({
    required this.id,
    required this.title,
    required this.filePath,
    required this.fileSize,
    required this.addedAt,
    this.author,
    this.publisher,
    this.isFavorite = false,
    this.readingStatus = 'Belum Dibaca',
    this.rating,
    this.note,
    this.lastReadPage = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'filePath': filePath,
      'fileSize': fileSize,
      'addedAt': addedAt.toIso8601String(),
      'author': author,
      'publisher': publisher,
      'isFavorite': isFavorite,
      'readingStatus': readingStatus,
      'rating': rating,
      'note': note,
      'lastReadPage': lastReadPage,
    };
  }

  factory PdfBook.fromJson(Map<String, dynamic> json) {
    return PdfBook(
      id: json['id'] as String,
      title: json['title'] as String,
      filePath: json['filePath'] as String,
      fileSize: json['fileSize'] as int,
      addedAt: DateTime.parse(json['addedAt'] as String),
      author: json['author'] as String?,
      publisher: json['publisher'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      readingStatus:
          json['readingStatus'] as String? ?? 'Belum Dibaca',
      rating: json['rating'] as int?,
      note: json['note'] as String?,
      lastReadPage: json['lastReadPage'] as int? ?? 1,
    );
  }

  PdfBook copyWith({
    String? author,
    String? publisher,
    bool? isFavorite,
    String? readingStatus,
    int? rating,
    bool clearRating = false,
    String? note,
    bool clearNote = false,
    int? lastReadPage,
  }) {
    return PdfBook(
      id: id,
      title: title,
      filePath: filePath,
      fileSize: fileSize,
      addedAt: addedAt,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      isFavorite: isFavorite ?? this.isFavorite,
      readingStatus: readingStatus ?? this.readingStatus,
      rating: clearRating ? null : (rating ?? this.rating),
      note: clearNote ? null : (note ?? this.note),
      lastReadPage: lastReadPage ?? this.lastReadPage,
    );
  }
}
