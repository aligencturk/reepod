import '../models/card_item.dart';

/// Mock veri servisi - Netflix benzeri içerikler için
class MockDataService {
  static final List<CardItem> _mockCards = [
    // AI Maceracı Kategorisi
    CardItem(
      id: '1',
      prompt: 'AI Generated: Epic Mountain Adventure',
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=600&fit=crop',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      style: 'AI Maceracı',
    ),
    CardItem(
      id: '2',
      prompt: 'AI Art: Forest Journey',
      imageUrl:
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&h=600&fit=crop',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      style: 'AI Maceracı',
    ),
    CardItem(
      id: '3',
      prompt: 'AI Generated: Lighthouse Night',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      style: 'AI Maceracı',
    ),

    // AI Fantastik Kategorisi
    CardItem(
      id: '4',
      prompt: 'AI Art: Magical Castle',
      imageUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      style: 'AI Fantastik',
    ),
    CardItem(
      id: '5',
      prompt: 'AI Generated: Dragon Fantasy',
      imageUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      style: 'AI Fantastik',
    ),

    // AI Portre Kategorisi
    CardItem(
      id: '6',
      prompt: 'AI Portrait: Digital Art',
      imageUrl:
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=600&fit=crop',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      style: 'AI Portre',
    ),
    CardItem(
      id: '7',
      prompt: 'AI Art: Character Design',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      style: 'AI Portre',
    ),

    // AI Bilim Kurgu Kategorisi
    CardItem(
      id: '8',
      prompt: 'AI Sci-Fi: Future City',
      imageUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      style: 'AI Bilim Kurgu',
    ),
    CardItem(
      id: '9',
      prompt: 'AI Generated: Space Station',
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=600&fit=crop',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      style: 'AI Bilim Kurgu',
    ),

    // AI Sanat Kategorisi
    CardItem(
      id: '10',
      prompt: 'AI Art: Abstract Expression',
      imageUrl:
          'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=400&h=600&fit=crop',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      style: 'AI Sanat',
    ),
    CardItem(
      id: '11',
      prompt: 'AI Generated: Digital Painting',
      imageUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      style: 'AI Sanat',
    ),

    // AI Mimari Kategorisi
    CardItem(
      id: '12',
      prompt: 'AI Architecture: Modern Building',
      imageUrl:
          'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=400&h=600&fit=crop',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      style: 'AI Mimari',
    ),
    CardItem(
      id: '13',
      prompt: 'AI Generated: Futuristic Design',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      style: 'AI Mimari',
    ),
  ];

  /// Tüm mock kartları getirir
  static List<CardItem> getAllCards() {
    return List.from(_mockCards);
  }

  /// Belirli bir kategorideki kartları getirir
  static List<CardItem> getCardsByCategory(String category) {
    return _mockCards.where((card) => card.style == category).toList();
  }

  /// En yeni kartları getirir
  static List<CardItem> getNewestCards({int limit = 10}) {
    final sortedCards = List<CardItem>.from(_mockCards);
    sortedCards.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedCards.take(limit).toList();
  }

  /// Trending kartları getirir (son 24 saatte oluşturulan)
  static List<CardItem> getTrendingCards({int limit = 10}) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    final trendingCards = _mockCards
        .where((card) => card.createdAt.isAfter(yesterday))
        .toList();

    trendingCards.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return trendingCards.take(limit).toList();
  }

  /// Featured kartı getirir (ana sayfa için)
  static CardItem? getFeaturedCard() {
    if (_mockCards.isEmpty) return null;
    return _mockCards.first;
  }

  /// Rastgele kart getirir
  static CardItem? getRandomCard() {
    if (_mockCards.isEmpty) return null;
    final random = DateTime.now().millisecondsSinceEpoch % _mockCards.length;
    return _mockCards[random];
  }

  /// Belirli bir ID'ye sahip kartı getirir
  static CardItem? getCardById(String id) {
    try {
      return _mockCards.firstWhere((card) => card.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Kart sayısını getirir
  static int getCardCount() {
    return _mockCards.length;
  }

  /// Kategori listesini getirir
  static List<String> getCategories() {
    return _mockCards.map((card) => card.style).toSet().toList();
  }
}
