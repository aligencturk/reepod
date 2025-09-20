import 'package:uuid/uuid.dart';
import '../models/card_item.dart';
import '../models/comment.dart';
import '../services/cache_service.dart';
import '../services/image_gen_service.dart';
import '../services/mock_data_service.dart';
import 'base_view_model.dart';

/// Kart işlemlerini yöneten ViewModel sınıfı
class CardViewModel extends BaseViewModel {
  final List<CardItem> _cards = [];
  final Uuid _uuid = const Uuid();

  /// Tüm kartları döndürür
  List<CardItem> get cards => List.unmodifiable(_cards);

  /// Kart sayısını döndürür
  int get cardCount => _cards.length;

  /// Cache'den kartları yükler (mock verilerle)
  Future<void> loadCards() async {
    await safeExecute(() async {
      // Önce cache'den yükle
      final cachedCards = await CacheService.getCards();
      
      // Eğer cache'de veri yoksa mock verileri yükle
      if (cachedCards.isEmpty) {
        final mockCards = MockDataService.getAllCards();
        _cards.clear();
        _cards.addAll(mockCards);
        
        // Mock verileri cache'e kaydet
        for (final card in mockCards) {
          await CacheService.addCard(card);
        }
      } else {
        _cards.clear();
        _cards.addAll(cachedCards);
      }
    }, errorPrefix: 'Kartlar yüklenirken hata');
  }

  /// Yeni bir kart oluşturur
  Future<bool> createCard({
    required String prompt,
    required String style,
  }) async {
    if (prompt.trim().isEmpty) {
      setError('Lütfen bir prompt metni girin');
      return false;
    }

    final result = await safeExecute(() async {
      // AI ile görsel üret
      final imageResult = await ImageGenService.generateImage(
        prompt: prompt,
        style: style,
        useDemo: true, // Demo modda çalış
      );

      if (!imageResult.isSuccess && imageResult.error != null) {
        throw Exception(imageResult.error!);
      }

      // Yeni kart oluştur
      final newCard = CardItem(
        id: _uuid.v4(),
        prompt: prompt,
        imageUrl: imageResult.imageUrl,
        style: style,
        createdAt: DateTime.now(),
      );

      // Listeye ekle (en başa)
      _cards.insert(0, newCard);

      // Cache'e kaydet
      final cacheSaved = await CacheService.addCard(newCard);
      if (!cacheSaved) {
        print('Kart cache\'e kaydedilemedi');
      }

      return true;
    }, errorPrefix: 'Kart oluşturulurken hata');

    return result ?? false;
  }

  /// Bir kartı beğenir/beğenmez
  Future<bool> toggleLike(String cardId) async {
    final result = await safeExecute(() async {
      final cardIndex = _cards.indexWhere((card) => card.id == cardId);
      if (cardIndex == -1) {
        throw Exception('Kart bulunamadı');
      }

      final card = _cards[cardIndex];
      final newLikeCount = card.isLiked ? card.likes - 1 : card.likes + 1;
      
      final updatedCard = card.copyWith(
        isLiked: !card.isLiked,
        likes: newLikeCount,
      );

      _cards[cardIndex] = updatedCard;

      // Cache'i güncelle
      await CacheService.updateCard(updatedCard);

      return true;
    }, errorPrefix: 'Beğeni işlemi sırasında hata', showLoading: false);

    return result ?? false;
  }

  /// Bir karta yorum ekler
  Future<bool> addComment({
    required String cardId,
    required String content,
    required String authorName,
  }) async {
    if (content.trim().isEmpty) {
      setError('Yorum metni boş olamaz');
      return false;
    }

    if (authorName.trim().isEmpty) {
      setError('Yazar adı belirtilmelidir');
      return false;
    }

    final result = await safeExecute(() async {
      final cardIndex = _cards.indexWhere((card) => card.id == cardId);
      if (cardIndex == -1) {
        throw Exception('Kart bulunamadı');
      }

      final card = _cards[cardIndex];
      
      // Yeni yorum oluştur
      final newComment = Comment(
        id: _uuid.v4(),
        authorName: authorName,
        content: content,
        createdAt: DateTime.now(),
      );

      // Yorumu karta ekle
      final updatedComments = [...card.comments, newComment];
      final updatedCard = card.copyWith(comments: updatedComments);

      _cards[cardIndex] = updatedCard;

      // Cache'i güncelle
      await CacheService.updateCard(updatedCard);

      return true;
    }, errorPrefix: 'Yorum eklenirken hata');

    return result ?? false;
  }

  /// Bir kartı siler
  Future<bool> deleteCard(String cardId) async {
    final result = await safeExecute(() async {
      final cardIndex = _cards.indexWhere((card) => card.id == cardId);
      if (cardIndex == -1) {
        throw Exception('Kart bulunamadı');
      }

      _cards.removeAt(cardIndex);

      // Cache'den sil
      await CacheService.deleteCard(cardId);

      return true;
    }, errorPrefix: 'Kart silinirken hata');

    return result ?? false;
  }

  /// Belirli bir kartı getirir
  CardItem? getCard(String cardId) {
    try {
      return _cards.firstWhere((card) => card.id == cardId);
    } catch (e) {
      return null;
    }
  }

  /// Kartları filtreleyerek arar
  List<CardItem> searchCards(String query) {
    if (query.trim().isEmpty) {
      return cards;
    }

    final lowercaseQuery = query.toLowerCase();
    return _cards.where((card) {
      return card.prompt.toLowerCase().contains(lowercaseQuery) ||
             card.style.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Kartları stil göre filtreler
  List<CardItem> getCardsByStyle(String style) {
    return _cards.where((card) => card.style == style).toList();
  }

  /// En çok beğenilen kartları döndürür
  List<CardItem> getMostLikedCards({int limit = 10}) {
    final sortedCards = List<CardItem>.from(_cards);
    sortedCards.sort((a, b) => b.likes.compareTo(a.likes));
    return sortedCards.take(limit).toList();
  }

  /// En yeni kartları döndürür
  List<CardItem> getNewestCards({int limit = 10}) {
    final sortedCards = List<CardItem>.from(_cards);
    sortedCards.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedCards.take(limit).toList();
  }

  /// Tüm kartları temizler
  Future<bool> clearAllCards() async {
    final result = await safeExecute(() async {
      _cards.clear();
      await CacheService.clearCache();
      return true;
    }, errorPrefix: 'Kartlar temizlenirken hata');

    return result ?? false;
  }

  /// Cache'i yeniden yükler
  Future<void> refreshCards() async {
    await safeExecute(() async {
      final cachedCards = await CacheService.getCards();
      _cards.clear();
      _cards.addAll(cachedCards);
    }, errorPrefix: 'Kartlar yenilenirken hata');
  }

  /// Mevcut stillerle istatistikleri döndürür
  Map<String, int> getStyleStatistics() {
    final stats = <String, int>{};
    for (final card in _cards) {
      stats[card.style] = (stats[card.style] ?? 0) + 1;
    }
    return stats;
  }

  /// Toplam beğeni sayısını döndürür
  int get totalLikes => _cards.fold(0, (total, card) => total + card.likes);

  /// Toplam yorum sayısını döndürür
  int get totalComments => _cards.fold(0, (total, card) => total + card.comments.length);

  /// En popüler stili döndürür
  String? get mostPopularStyle {
    final stats = getStyleStatistics();
    if (stats.isEmpty) return null;
    
    return stats.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}

