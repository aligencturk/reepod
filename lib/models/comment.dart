/// Kart üzerinde yapılan yorumu temsil eden model
class Comment {
  /// Yorumun benzersiz kimliği
  final String id;
  
  /// Yorum yapan kullanıcının adı
  final String authorName;
  
  /// Yorumun içeriği
  final String content;
  
  /// Yorumun yapıldığı zaman
  final DateTime createdAt;
  
  /// Kullanıcının profil resmi URL'i (opsiyonel)
  final String? avatarUrl;

  const Comment({
    required this.id,
    required this.authorName,
    required this.content,
    required this.createdAt,
    this.avatarUrl,
  });

  /// JSON'dan Comment oluşturur
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      authorName: json['authorName'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  /// Comment'ı JSON'a dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'avatarUrl': avatarUrl,
    };
  }

  /// Comment'ın kopyasını oluşturur
  Comment copyWith({
    String? id,
    String? authorName,
    String? content,
    DateTime? createdAt,
    String? avatarUrl,
  }) {
    return Comment(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Comment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Comment(id: $id, authorName: $authorName, content: $content)';
  }
}

