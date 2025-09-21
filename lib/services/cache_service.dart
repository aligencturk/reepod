import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_item.dart';
import '../utils/logger_util.dart';

/// Lokal cache işlemlerini yöneten servis sınıfı
class CacheService {
  static const String _cardsKey = 'cached_cards';
  static const String _userPrefsKey = 'user_preferences';
  static const String _lastUpdateKey = 'last_update';

  /// SharedPreferences instance'ını döndürür
  static Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  /// Kartları cache'e kaydeder
  static Future<bool> saveCards(List<CardItem> cards) async {
    try {
      final prefs = await _prefs;
      final cardsJson = cards.map((card) => card.toJson()).toList();
      final cardsString = json.encode(cardsJson);

      final success = await prefs.setString(_cardsKey, cardsString);
      if (success) {
        await _updateLastCacheTime();
      }

      return success;
    } catch (e) {
      LoggerUtil.error('Kartlar kaydedilirken hata oluştu', e);
      return false;
    }
  }

  /// Cache'den kartları getirir
  static Future<List<CardItem>> getCards() async {
    try {
      final prefs = await _prefs;
      final cardsString = prefs.getString(_cardsKey);

      if (cardsString == null) {
        return [];
      }

      final cardsJson = json.decode(cardsString) as List<dynamic>;
      final cards = cardsJson
          .map(
            (cardJson) => CardItem.fromJson(cardJson as Map<String, dynamic>),
          )
          .toList();

      return cards;
    } catch (e) {
      LoggerUtil.error('Kartlar yüklenirken hata oluştu', e);
      return [];
    }
  }

  /// Yeni bir kart ekler (listenin başına)
  static Future<bool> addCard(CardItem card) async {
    try {
      final cards = await getCards();
      cards.insert(0, card); // Yeni kartı en başa ekle

      // Maximum 50 kart tutulması için sınırlama
      if (cards.length > 50) {
        cards.removeRange(50, cards.length);
      }

      return await saveCards(cards);
    } catch (e) {
      LoggerUtil.error('Kart eklenirken hata oluştu', e);
      return false;
    }
  }

  /// Bir kartı günceller
  static Future<bool> updateCard(CardItem updatedCard) async {
    try {
      final cards = await getCards();
      final cardIndex = cards.indexWhere((card) => card.id == updatedCard.id);

      if (cardIndex != -1) {
        cards[cardIndex] = updatedCard;
        return await saveCards(cards);
      }

      return false;
    } catch (e) {
      LoggerUtil.error('Kart güncellenirken hata oluştu', e);
      return false;
    }
  }

  /// Bir kartı siler
  static Future<bool> deleteCard(String cardId) async {
    try {
      final cards = await getCards();
      cards.removeWhere((card) => card.id == cardId);
      return await saveCards(cards);
    } catch (e) {
      LoggerUtil.error('Kart silinirken hata oluştu', e);
      return false;
    }
  }

  /// Cache'i temizler
  static Future<bool> clearCache() async {
    try {
      final prefs = await _prefs;
      return await prefs.remove(_cardsKey);
    } catch (e) {
      LoggerUtil.error('Cache temizlenirken hata oluştu', e);
      return false;
    }
  }

  /// Kullanıcı tercihlerini kaydeder
  static Future<bool> saveUserPreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      final prefs = await _prefs;
      final preferencesString = json.encode(preferences);
      return await prefs.setString(_userPrefsKey, preferencesString);
    } catch (e) {
      LoggerUtil.error('Kullanıcı tercihleri kaydedilirken hata oluştu', e);
      return false;
    }
  }

  /// Kullanıcı tercihlerini getirir
  static Future<Map<String, dynamic>> getUserPreferences() async {
    try {
      final prefs = await _prefs;
      final preferencesString = prefs.getString(_userPrefsKey);

      if (preferencesString == null) {
        return <String, dynamic>{};
      }

      return json.decode(preferencesString) as Map<String, dynamic>;
    } catch (e) {
      LoggerUtil.error('Kullanıcı tercihleri yüklenirken hata oluştu', e);
      return <String, dynamic>{};
    }
  }

  /// Son cache güncelleme zamanını kaydeder
  static Future<void> _updateLastCacheTime() async {
    try {
      final prefs = await _prefs;
      final now = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(_lastUpdateKey, now);
    } catch (e) {
      LoggerUtil.error('Son güncelleme zamanı kaydedilirken hata oluştu', e);
    }
  }

  /// Son cache güncelleme zamanını getirir
  static Future<DateTime?> getLastCacheTime() async {
    try {
      final prefs = await _prefs;
      final timestamp = prefs.getInt(_lastUpdateKey);

      if (timestamp == null) {
        return null;
      }

      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      LoggerUtil.error('Son güncelleme zamanı alınırken hata oluştu', e);
      return null;
    }
  }

  /// Cache'in geçerli olup olmadığını kontrol eder
  static Future<bool> isCacheValid({
    Duration maxAge = const Duration(hours: 24),
  }) async {
    final lastUpdate = await getLastCacheTime();

    if (lastUpdate == null) {
      return false;
    }

    return DateTime.now().difference(lastUpdate) < maxAge;
  }

  /// Cache boyutunu bytes cinsinden döndürür
  static Future<int> getCacheSize() async {
    try {
      final prefs = await _prefs;
      final cardsString = prefs.getString(_cardsKey) ?? '';
      final preferencesString = prefs.getString(_userPrefsKey) ?? '';

      return cardsString.length + preferencesString.length;
    } catch (e) {
      LoggerUtil.error('Cache boyutu hesaplanırken hata oluştu', e);
      return 0;
    }
  }

  /// Belirli bir anahtar değerini kaydeder
  static Future<bool> setValue<T>(String key, T value) async {
    try {
      final prefs = await _prefs;

      if (value is String) {
        return await prefs.setString(key, value);
      } else if (value is int) {
        return await prefs.setInt(key, value);
      } else if (value is double) {
        return await prefs.setDouble(key, value);
      } else if (value is bool) {
        return await prefs.setBool(key, value);
      } else if (value is List<String>) {
        return await prefs.setStringList(key, value);
      } else {
        // Complex objects JSON olarak sakla
        return await prefs.setString(key, json.encode(value));
      }
    } catch (e) {
      LoggerUtil.error('Değer kaydedilirken hata oluştu', e);
      return false;
    }
  }

  /// Belirli bir anahtar değerini getirir
  static Future<T?> getValue<T>(String key) async {
    try {
      final prefs = await _prefs;
      return prefs.get(key) as T?;
    } catch (e) {
      LoggerUtil.error('Değer alınırken hata oluştu', e);
      return null;
    }
  }
}
