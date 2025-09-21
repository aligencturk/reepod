/// AI tarafından üretilen görsel kartını temsil eden model
class CardItem {
  /// Kartın benzersiz kimliği
  final String id;

  /// Kullanıcının girdiği prompt metni
  final String prompt;

  /// Üretilen görselin URL'i
  final String imageUrl;

  /// Kartın oluşturulma zamanı
  final DateTime createdAt;

  /// Kullanıcının seçtiği görsel stili
  final String style;

  const CardItem({
    required this.id,
    required this.prompt,
    required this.imageUrl,
    required this.createdAt,
    this.style = 'Realistik',
  });

  /// JSON'dan CardItem oluşturur
  factory CardItem.fromJson(Map<String, dynamic> json) {
    return CardItem(
      id: json['id'] as String,
      prompt: json['prompt'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      style: json['style'] as String? ?? 'Realistik',
    );
  }

  /// CardItem'ı JSON'a dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'style': style,
    };
  }

  /// CardItem'ın kopyasını oluşturur (immutable yapı için)
  CardItem copyWith({
    String? id,
    String? prompt,
    String? imageUrl,
    DateTime? createdAt,
    String? style,
  }) {
    return CardItem(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      style: style ?? this.style,
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
    return 'CardItem(id: $id, prompt: $prompt, style: $style)';
  }
}
