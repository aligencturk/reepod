import '../models/card_item.dart';

/// Mock veri servisi - Netflix benzeri içerikler için
class MockDataService {
  static final List<CardItem> _mockCards = [
    // AI Maceracı Kategorisi
    CardItem(
      id: '1',
      prompt: 'AI Generated: Epic Mountain Adventure',
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=600&fit=crop',
      likes: 1247,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      style: 'AI Maceracı',
      isLiked: true,
    ),
    CardItem(
      id: '2',
      prompt: 'AI Art: Forest Journey',
      imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&h=600&fit=crop',
      likes: 892,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      style: 'AI Maceracı',
      isLiked: false,
    ),
    CardItem(
      id: '3',
      prompt: 'AI Generated: Lighthouse Night',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop',
      likes: 2156,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      style: 'AI Maceracı',
      isLiked: true,
    ),
    CardItem(
      id: '4',
      prompt: 'AI Art: Desert Expedition',
      imageUrl: 'https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?w=400&h=600&fit=crop',
      likes: 743,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      style: 'AI Maceracı',
      isLiked: false,
    ),
    CardItem(
      id: '5',
      prompt: 'AI Generated: Northern Lights',
      imageUrl: 'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=400&h=600&fit=crop',
      likes: 3421,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      style: 'AI Maceracı',
      isLiked: true,
    ),
    
    // AI Fantastik Kategorisi
    CardItem(
      id: '6',
      prompt: 'AI Art: Dragon Castle',
      imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop',
      likes: 1892,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      style: 'AI Fantastik',
      isLiked: false,
    ),
    CardItem(
      id: '7',
      prompt: 'AI Generated: Magical Forest',
      imageUrl: 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400&h=600&fit=crop',
      likes: 1654,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      style: 'AI Fantastik',
      isLiked: true,
    ),
    CardItem(
      id: '8',
      prompt: 'AI Art: Space Station',
      imageUrl: 'https://images.unsplash.com/photo-1446776877081-d282a0f896e2?w=400&h=600&fit=crop',
      likes: 2789,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      style: 'AI Fantastik',
      isLiked: false,
    ),
    
    // AI Portre Kategorisi
    CardItem(
      id: '9',
      prompt: 'AI Portrait: Cyberpunk Character',
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&h=600&fit=crop',
      likes: 1234,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      style: 'AI Portre',
      isLiked: true,
    ),
    CardItem(
      id: '10',
      prompt: 'AI Generated: Fantasy Portrait',
      imageUrl: 'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=400&h=600&fit=crop',
      likes: 987,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      style: 'AI Portre',
      isLiked: false,
    ),
    
    // AI Bilim Kurgu Kategorisi
    CardItem(
      id: '11',
      prompt: 'AI Art: Cyberpunk City',
      imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop',
      likes: 3456,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      style: 'AI Bilim Kurgu',
      isLiked: true,
    ),
    CardItem(
      id: '12',
      prompt: 'AI Generated: Robot World',
      imageUrl: 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=400&h=600&fit=crop',
      likes: 2109,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      style: 'AI Bilim Kurgu',
      isLiked: false,
    ),
    
    // AI Sanat Kategorisi
    CardItem(
      id: '13',
      prompt: 'AI Art: Abstract Digital',
      imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400&h=600&fit=crop',
      likes: 876,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      style: 'AI Sanat',
      isLiked: true,
    ),
    CardItem(
      id: '14',
      prompt: 'AI Generated: Neon Aesthetic',
      imageUrl: 'https://images.unsplash.com/photo-1513639776629-7b61b0ac49cb?w=400&h=600&fit=crop',
      likes: 1123,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      style: 'AI Sanat',
      isLiked: false,
    ),
    
    // AI Mimari Kategorisi
    CardItem(
      id: '15',
      prompt: 'AI Architecture: Futuristic Building',
      imageUrl: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=400&h=600&fit=crop',
      likes: 1456,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      style: 'AI Mimari',
      isLiked: true,
    ),
    CardItem(
      id: '16',
      prompt: 'AI Generated: Modern Cityscape',
      imageUrl: 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400&h=600&fit=crop',
      likes: 2234,
      comments: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      style: 'AI Mimari',
      isLiked: false,
    ),
  ];

  /// Tüm mock kartları getirir
  static List<CardItem> getAllCards() {
    return List.from(_mockCards);
  }

  /// Belirli bir kategoriye göre kartları filtreler
  static List<CardItem> getCardsByCategory(String category) {
    return _mockCards.where((card) => card.style == category).toList();
  }

  /// En çok beğenilen kartları getirir
  static List<CardItem> getMostLikedCards() {
    final sortedCards = List<CardItem>.from(_mockCards);
    sortedCards.sort((a, b) => b.likes.compareTo(a.likes));
    return sortedCards;
  }

  /// Yeni eklenen kartları getirir
  static List<CardItem> getNewestCards() {
    final sortedCards = List<CardItem>.from(_mockCards);
    sortedCards.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedCards;
  }

  /// Trending kartları getirir (son 24 saatte en çok beğenilen)
  static List<CardItem> getTrendingCards() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final trendingCards = _mockCards
        .where((card) => card.createdAt.isAfter(yesterday))
        .toList();
    trendingCards.sort((a, b) => b.likes.compareTo(a.likes));
    return trendingCards;
  }

  /// Kategorileri getirir
  static List<String> getCategories() {
    return ['AI Maceracı', 'AI Fantastik', 'AI Portre', 'AI Bilim Kurgu', 'AI Sanat', 'AI Mimari'];
  }

  /// Hero section için öne çıkan kartı getirir
  static CardItem? getFeaturedCard() {
    if (_mockCards.isEmpty) return null;
    return _mockCards.first; // İlk kartı featured olarak döndür
  }
}
