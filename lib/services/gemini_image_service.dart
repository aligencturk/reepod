import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../config/api_config.dart';

/// Google Gemini v1beta REST API ile görsel üretimi ve düzenleme servisi
/// Sadece gemini-2.5-flash-image-preview modeli kullanır
class GeminiImageService {
  final String apiKey;
  final Logger _logger = Logger();

  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const String _model = 'gemini-2.5-flash-image-preview';
  static const Duration _timeout = Duration(seconds: 60);

  GeminiImageService(this.apiKey);

  /// Constructor ile API key injection (tercih edilen yöntem)
  factory GeminiImageService.fromConfig() {
    return GeminiImageService(ApiConfig.geminiApiKey);
  }

  /// .env dosyasından API key al
  factory GeminiImageService.fromEnv() {
    final key = dotenv.env['GEMINI_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env file');
    }
    return GeminiImageService(key);
  }

  /// Görsel üretimi
  ///
  /// Örnek kullanım:
  /// ```dart
  /// final svc = GeminiImageService.fromConfig();
  /// final bytes = await svc.generateImage(
  ///   prompt: '1024x1024 photorealistic sunset over a lake, wooden pier, warm tones',
  ///   outputMimeType: 'image/png',
  /// );
  /// ```
  Future<Uint8List> generateImage({
    required String prompt,
    int? width,
    int? height,
    double? temperature,
    Map<String, dynamic>? extraConfig,
  }) async {
    try {
      _logger.i('Gemini görsel üretimi başlatılıyor: $prompt');

      // Boyut bilgisini prompt'a ekle
      String enhancedPrompt = prompt;
      if (width != null && height != null) {
        enhancedPrompt = '${width}x${height} $prompt';
      }

      final requestBody = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': enhancedPrompt},
            ],
          },
        ],
        'generationConfig': {
          if (temperature != null) 'temperature': temperature,
          ...?extraConfig,
        },
      };

      final response = await _postJson(
        '/models/$_model:generateContent',
        requestBody,
      );

      final imageBytes = _parseImageResponse(response);

      _logger.i('Gemini görsel üretimi tamamlandı: ${imageBytes.length} bytes');
      return imageBytes;
    } catch (e) {
      _logger.e('Gemini görsel üretim hatası: $e');
      rethrow;
    }
  }

  /// Görsel düzenleme
  ///
  /// Örnek kullanım:
  /// ```dart
  /// final svc = GeminiImageService.fromConfig();
  /// final edited = await svc.editImage(
  ///   inputImageBytes: originalBytes,
  ///   instruction: 'Slight background blur and warmer sky tones',
  ///   inputMimeType: 'image/jpeg',
  ///   outputMimeType: 'image/png',
  /// );
  /// ```
  Future<Uint8List> editImage({
    required Uint8List inputImageBytes,
    required String instruction,
    String inputMimeType = 'image/jpeg',
    double? temperature,
    Map<String, dynamic>? extraConfig,
  }) async {
    try {
      _logger.i('Gemini görsel düzenleme başlatılıyor: $instruction');

      final base64Image = base64Encode(inputImageBytes);

      final requestBody = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': instruction},
              {
                'inlineData': {'mimeType': inputMimeType, 'data': base64Image},
              },
            ],
          },
        ],
        'generationConfig': {
          if (temperature != null) 'temperature': temperature,
          ...?extraConfig,
        },
      };

      final response = await _postJson(
        '/models/$_model:generateContent',
        requestBody,
      );

      final imageBytes = _parseImageResponse(response);

      _logger.i(
        'Gemini görsel düzenleme tamamlandı: ${imageBytes.length} bytes',
      );
      return imageBytes;
    } catch (e) {
      _logger.e('Gemini görsel düzenleme hatası: $e');
      rethrow;
    }
  }

  /// HTTP POST isteği gönder
  Future<Map<String, dynamic>> _postJson(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$_baseUrl$endpoint?key=$apiKey');

    _logger.d('Base URL: $_baseUrl');
    _logger.d('Model: $_model');
    _logger.d('Endpoint: $endpoint');
    _logger.d('Full URL: $url');
    _logger.d('Request body: ${jsonEncode(body)}');

    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(_timeout);

    _logger.d('Response status: ${response.statusCode}');
    _logger.d('Response body: ${response.body}');

    // geçici debug - ham yanıt:
    _logger.d('=== GEMINI API RESPONSE ===');
    _logger.d(response.body);
    _logger.d('=== END RESPONSE ===');

    if (response.statusCode != 200) {
      try {
        final errorData = jsonDecode(response.body);
        final error = errorData['error'];
        if (error != null) {
          final code = error['code'] ?? 'UNKNOWN';
          final message = error['message'] ?? 'Unknown error';
          throw Exception('Gemini image error: $code $message');
        }
      } catch (e) {
        // JSON parse hatası
      }
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }

    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Invalid JSON response: $e');
    }
  }

  /// API yanıtından görsel verisini çıkar
  Uint8List _parseImageResponse(Map<String, dynamic> response) {
    try {
      _logger.d('Parsing response: ${jsonEncode(response)}');

      final candidates = (response['candidates'] as List?) ?? const [];
      if (candidates.isEmpty) {
        // Güvenlik blokajı vb. durumlar için açıklayıcı hata ver
        final br =
            response['promptFeedback']?['blockReason'] ??
            response['prompt_feedback']?['block_reason'] ??
            "no candidates";
        _logger.e('No candidates in response: $br');
        throw Exception('No image returned: $br');
      }

      _logger.d('Found ${candidates.length} candidates');

      String? b64;
      String? firstText; // debug amaçlı

      for (int i = 0; i < candidates.length; i++) {
        final c = candidates[i];
        final parts = (c['content']?['parts'] as List?) ?? const [];
        _logger.d('Candidate $i has ${parts.length} parts');

        for (int j = 0; j < parts.length; j++) {
          final p = parts[j];
          _logger.d('Part $j: ${jsonEncode(p)}');

          // 1) Görsel
          final inline =
              (p['inline_data']?['data']) ?? (p['inlineData']?['data']);
          if (inline is String && inline.isNotEmpty) {
            _logger.d('Found inline_data with data, length: ${inline.length}');
            b64 = inline;
            break;
          }

          // 2) Metin (log etmek için sakla)
          final txt = p['text'];
          if (firstText == null && txt is String && txt.isNotEmpty) {
            firstText = txt;
            _logger.d('Found text in part $j: $txt');
          }
        }
        if (b64 != null) break;
      }

      if (b64 == null) {
        final fr =
            candidates[0]['finish_reason'] ?? candidates[0]['finishReason'];
        _logger.e('No image data found, finishReason: $fr');
        if (firstText != null) {
          _logger.e('First text found: $firstText');
        }
        throw Exception('No image returned (finishReason=$fr)');
      }

      return _decodeB64ToBytes(b64);
    } catch (e) {
      _logger.e('Error parsing image response: $e');
      throw Exception('No image returned: $e');
    }
  }

  /// Base64 string'i Uint8List'e çevir
  Uint8List _decodeB64ToBytes(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      throw Exception('Failed to decode base64 image data: $e');
    }
  }
}
