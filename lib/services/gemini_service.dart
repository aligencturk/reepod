import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:logger/logger.dart';
import '../config/api_config.dart';

/// Google Gemini API servisi
/// Görsel ve metin üretimi için kullanılır
class GeminiService {
  static final Logger _logger = Logger();
  static GenerativeModel? _model;
  static GenerativeModel? _imageModel;

  /// Gemini modelini başlat
  static void _initializeModel() {
    try {
      _model = GenerativeModel(
        model: ApiConfig.geminiTextModel,
        apiKey: ApiConfig.geminiApiKey,
      );
      
      _imageModel = GenerativeModel(
        model: ApiConfig.geminiImageModel,
        apiKey: ApiConfig.geminiApiKey,
      );
      
      _logger.i('Gemini modelleri başarıyla başlatıldı');
    } catch (e) {
      _logger.e('Gemini model başlatma hatası: $e');
      rethrow;
    }
  }

  /// Metin üretimi
  static Future<String> generateText(String prompt) async {
    try {
      _initializeModel();
      
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      _logger.i('Gemini metin üretimi tamamlandı');
      return response.text ?? 'Metin üretilemedi';
    } catch (e) {
      _logger.e('Gemini metin üretim hatası: $e');
      throw Exception('Metin üretimi başarısız: $e');
    }
  }

  /// Görsel üretimi (Gemini 2.5 Flash Image Preview)
  static Future<List<Uint8List>> generateImages(String prompt, {int count = 1}) async {
    try {
      _initializeModel();
      
      final content = [Content.text(prompt)];
      final response = await _imageModel!.generateContent(content);
      
      List<Uint8List> images = [];
      
      // Gemini 2.5 Flash Image Preview'dan gelen görselleri işle
      if (response.candidates?.isNotEmpty == true) {
        final candidate = response.candidates!.first;
        if (candidate.content?.parts?.isNotEmpty == true) {
          for (final part in candidate.content!.parts!) {
            // Gemini 2.5 Flash Image Preview henüz görsel üretimi desteklemiyor olabilir
            // Sadece metin yanıtı bekleniyor
            final partText = part.toString();
            if (partText.isNotEmpty) {
              // Bu durumda sadece metin yanıtı döndürülecek
            }
          }
        }
      }
      
      _logger.i('Gemini görsel üretimi tamamlandı: ${images.length} görsel');
      return images;
    } catch (e) {
      _logger.e('Gemini görsel üretim hatası: $e');
      throw Exception('Görsel üretimi başarısız: $e');
    }
  }

  /// Görsel analizi (Vision model)
  static Future<String> analyzeImage(Uint8List imageData, String prompt) async {
    try {
      _initializeModel();
      
      final visionModel = GenerativeModel(
        model: ApiConfig.geminiVisionModel,
        apiKey: ApiConfig.geminiApiKey,
      );
      
      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageData),
        ])
      ];
      
      final response = await visionModel.generateContent(content);
      
      _logger.i('Gemini görsel analizi tamamlandı');
      return response.text ?? 'Görsel analiz edilemedi';
    } catch (e) {
      _logger.e('Gemini görsel analiz hatası: $e');
      throw Exception('Görsel analizi başarısız: $e');
    }
  }

  /// Karma içerik üretimi (metin + görsel)
  static Future<Map<String, dynamic>> generateMixedContent(String prompt) async {
    try {
      _initializeModel();
      
      final content = [Content.text(prompt)];
      final response = await _imageModel!.generateContent(content);
      
      String text = '';
      List<Uint8List> images = [];
      
      if (response.candidates?.isNotEmpty == true) {
        final candidate = response.candidates!.first;
        if (candidate.content?.parts?.isNotEmpty == true) {
          for (final part in candidate.content!.parts!) {
            final partText = part.toString();
            if (partText.isNotEmpty && !partText.startsWith('[')) {
              text += partText;
            }
            // Görsel verisi için farklı bir yaklaşım gerekli
          }
        }
      }
      
      _logger.i('Gemini karma içerik üretimi tamamlandı');
      return {
        'text': text,
        'images': images,
      };
    } catch (e) {
      _logger.e('Gemini karma içerik üretim hatası: $e');
      throw Exception('Karma içerik üretimi başarısız: $e');
    }
  }

  /// API anahtarını test et
  static Future<bool> testApiKey() async {
    try {
      _initializeModel();
      await generateText('Test');
      _logger.i('Gemini API anahtarı geçerli');
      return true;
    } catch (e) {
      _logger.e('Gemini API anahtarı geçersiz: $e');
      return false;
    }
  }
}
