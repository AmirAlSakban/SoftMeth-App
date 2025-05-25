class Tutorial {
  final int? id;
  final String title;
  final String description;
  final String? category;
  final String? author;
  final String? difficultyLevel;
  final int? durationMinutes;
  final bool published;
  final bool featured;
  final String? imageUrl;
  final String? videoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Tutorial({
    this.id,
    required this.title,
    required this.description,
    this.category,
    this.author,
    this.difficultyLevel,
    this.durationMinutes,
    this.published = false,
    this.featured = false,
    this.imageUrl,
    this.videoUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    return Tutorial(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'],
      author: json['author'],
      difficultyLevel: json['difficultyLevel'],
      durationMinutes: json['durationMinutes'],
      published: json['published'] ?? false,
      featured: json['featured'] ?? false,
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'author': author,
      'difficultyLevel': difficultyLevel,
      'durationMinutes': durationMinutes,
      'published': published,
      'featured': featured,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Tutorial copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? author,
    String? difficultyLevel,
    int? durationMinutes,
    bool? published,
    bool? featured,
    String? imageUrl,
    String? videoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tutorial(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      author: author ?? this.author,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      published: published ?? this.published,
      featured: featured ?? this.featured,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Tutorial{id: $id, title: $title, category: $category, author: $author, published: $published}';
  }
}
