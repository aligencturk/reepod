import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../config/api_config.dart';

/// OpenAI API Service
/// AI görsel oluşturma işlemlerini yönetir
class OpenAIService {
  static final Logger _logger = Logger();
  
  final http.Client _client = http.Client();

  /// AI ile görsel oluştur
  /// [prompt] - Görsel açıklaması
  /// [style] - Stil (opsiyonel)
  /// [size] - Görsel boyutu (varsayılan: 1024x1024)
  Future<Uint8List?> generateImage({
    required String prompt,
    String? style,
    String size = '1024x1024',
  }) async {
    try {
      _logger.i('=== AI Görsel Oluşturma Başlatıldı ===');
      _logger.i('Orijinal Prompt: $prompt');
      _logger.i('Seçilen Stil: $style');
      _logger.i('Görsel Boyutu: $size');
      _logger.i('Kullanılan Model: ${ApiConfig.defaultImageModel}');
      _logger.i('API Key: ${ApiConfig.openaiApiKey.substring(0, 20)}...');
      
      final enhancedPrompt = _enhancePrompt(prompt, style);
      _logger.i('Geliştirilmiş Prompt: $enhancedPrompt');
      
      _logger.i('OpenAI API\'ye istek gönderiliyor...');
      final response = await _client.post(
        Uri.parse('${ApiConfig.openaiBaseUrl}/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConfig.openaiApiKey}',
        },
        body: jsonEncode({
          'model': ApiConfig.defaultImageModel,
          'prompt': enhancedPrompt,
          'n': 1,
          'size': size,
          'quality': ApiConfig.defaultImageQuality,
          'style': ApiConfig.defaultImageStyle,
        }),
      );

      _logger.i('API Response Status: ${response.statusCode}');
      _logger.i('Response Headers: ${response.headers}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _logger.i('API Response Data: $data');
        
        // Token kullanımı ve maliyet bilgisi
        if (data.containsKey('usage')) {
          final usage = data['usage'];
          _logger.i('=== Token Kullanımı ===');
          _logger.i('Prompt Tokens: ${usage['prompt_tokens'] ?? 'N/A'}');
          _logger.i('Completion Tokens: ${usage['completion_tokens'] ?? 'N/A'}');
          _logger.i('Total Tokens: ${usage['total_tokens'] ?? 'N/A'}');
          
          // Tahmini maliyet hesaplama (DALL-E 3 için)
          final totalTokens = usage['total_tokens'] ?? 0;
          final estimatedCost = totalTokens * 0.0001; // Yaklaşık maliyet
          _logger.i('Tahmini Maliyet: \$${estimatedCost.toStringAsFixed(4)}');
        }
        
        final imageUrl = data['data'][0]['url'];
        _logger.i('Görsel URL: $imageUrl');
        
        // Görseli indir
        _logger.i('Görsel indiriliyor...');
        final imageData = await _downloadImage(imageUrl);
        
        if (imageData != null) {
          _logger.i('Görsel başarıyla indirildi. Boyut: ${imageData.length} bytes');
          _logger.i('=== AI Görsel Oluşturma Tamamlandı ===');
        } else {
          _logger.e('Görsel indirilemedi!');
        }
        
        return imageData;
      } else {
        _logger.e('OpenAI API Error: ${response.statusCode}');
        _logger.e('Error Response: ${response.body}');
        return null;
      }
    } catch (e) {
      _logger.e('OpenAI Service Error: $e');
      _logger.e('Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  /// Prompt'u stil ile geliştir
  String _enhancePrompt(String prompt, String? style) {
    String enhancedPrompt = prompt;
    
    if (style != null && style.isNotEmpty) {
      switch (style) {
        case 'AI Maceracı':
          enhancedPrompt = 'Epic adventure scene, $prompt, dramatic lighting, cinematic composition, high quality, detailed';
          break;
        case 'AI Fantastik':
          enhancedPrompt = 'Fantasy art, magical, $prompt, mystical atmosphere, ethereal lighting, digital art style';
          break;
        case 'AI Portre':
          enhancedPrompt = 'Portrait photography, $prompt, professional lighting, high resolution, detailed facial features';
          break;
        case 'AI Bilim Kurgu':
          enhancedPrompt = 'Sci-fi art, futuristic, $prompt, cyberpunk style, neon lights, high tech atmosphere';
          break;
        case 'AI Sanat':
          enhancedPrompt = 'Artistic painting, $prompt, creative interpretation, artistic style, beautiful composition';
          break;
        case 'AI Mimari':
          enhancedPrompt = 'Architectural photography, $prompt, modern design, clean lines, professional photography';
          break;
        default:
          enhancedPrompt = 'High quality, detailed, $prompt, professional photography';
      }
    } else {
      enhancedPrompt = 'High quality, detailed, $prompt, professional photography';
    }
    
    return enhancedPrompt;
  }

  /// Görseli URL'den indir
  Future<Uint8List?> _downloadImage(String imageUrl) async {
    try {
      final response = await _client.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      print('Image download error: $e');
      return null;
    }
  }

  /// Text-to-Image için alternatif yöntem (DALL-E 2)
  Future<Uint8List?> generateImageDALLE2({
    required String prompt,
    String? style,
    String size = '1024x1024',
  }) async {
    try {
      final enhancedPrompt = _enhancePrompt(prompt, style);
      
      final response = await _client.post(
        Uri.parse('${ApiConfig.openaiBaseUrl}/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConfig.openaiApiKey}',
        },
        body: jsonEncode({
          'model': ApiConfig.fallbackImageModel,
          'prompt': enhancedPrompt,
          'n': 1,
          'size': size,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final imageUrl = data['data'][0]['url'];
        
        return await _downloadImage(imageUrl);
      } else {
        print('OpenAI API Error: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      _logger.e('OpenAI Service Error: $e');
      _logger.e('Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  /// API kullanım durumunu kontrol et
  Future<bool> checkApiStatus() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.openaiBaseUrl}/models'),
        headers: {
          'Authorization': 'Bearer ${ApiConfig.openaiApiKey}',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('API Status Check Error: $e');
      return false;
    }
  }

  /// Servisi temizle
  void dispose() {
    _client.close();
  }
}
