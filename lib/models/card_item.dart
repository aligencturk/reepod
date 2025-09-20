import 'comment.dart';

/// AI tarafından üretilen görsel kartını temsil eden model
class CardItem {
  /// Kartın benzersiz kimliği
  final String id;
  
  /// Kullanıcının girdiği prompt metni
  final String prompt;
  
  /// Üretilen görselin URL'i
  final String imageUrl;
  
  /// Kartın aldığı beğeni sayısı
  final int likes;
  
  /// Kartta yapılan yorumlar
  final List<Comment> comments;
  
  /// Kartın oluşturulma zamanı
  final DateTime createdAt;
  
  /// Kullanıcının seçtiği görsel stili
  final String style;
  
  /// Kartın şu anda beğenilmiş olup olmadığı
  final bool isLiked;

  const CardItem({
    required this.id,
    required this.prompt,
    required this.imageUrl,
    this.likes = 0,
    this.comments = const [],
    required this.createdAt,
    this.style = 'Realistik',
    this.isLiked = false,
  });

  /// JSON'dan CardItem oluşturur
  factory CardItem.fromJson(Map<String, dynamic> json) {
    return CardItem(
      id: json['id'] as String,
      prompt: json['prompt'] as String,
      imageUrl: json['imageUrl'] as String,
      likes: json['likes'] as int? ?? 0,
      comments: (json['comments'] as List<dynamic>?)
              ?.map((commentJson) => Comment.fromJson(commentJson))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      style: json['style'] as String? ?? 'Realistik',
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  /// CardItem'ı JSON'a dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'imageUrl': imageUrl,
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'style': style,
      'isLiked': isLiked,
    };
  }

  /// CardItem'ın kopyasını oluşturur (immutable yapı için)
  CardItem copyWith({
    String? id,
    String? prompt,
    String? imageUrl,
    int? likes,
    List<Comment>? comments,
    DateTime? createdAt,
    String? style,
    bool? isLiked,
  }) {
    return CardItem(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      style: style ?? this.style,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CardItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CardItem(id: $id, prompt: $prompt, likes: $likes, style: $style)';
  }
}

