import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// HTTP isteklerini ve API hatalarını yöneten temel servis sınıfı
class ApiService {
  static const Duration _timeout = Duration(seconds: 30);
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// GET isteği yapar
  static Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: {..._defaultHeaders, ...?headers},
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw const ApiException('İnternet bağlantısı bulunamadı');
    } on HttpException {
      throw const ApiException('HTTP hatası oluştu');
    } catch (e) {
      throw ApiException('Beklenmedik hata: $e');
    }
  }

  /// POST isteği yapar
  static Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {..._defaultHeaders, ...?headers},
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw const ApiException('İnternet bağlantısı bulunamadı');
    } on HttpException {
      throw const ApiException('HTTP hatası oluştu');
    } catch (e) {
      throw ApiException('Beklenmedik hata: $e');
    }
  }

  /// Multipart form data POST isteği yapar (dosya yükleme için)
  static Future<Map<String, dynamic>> postMultipart(
    String url, {
    Map<String, String>? fields,
    Map<String, String>? files,
    Map<String, String>? headers,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));

      // Headers ekleme
      if (headers != null) {
        request.headers.addAll(headers);
      }

      // Fields ekleme
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Dosyaları ekleme
      if (files != null) {
        for (final entry in files.entries) {
          final file = await http.MultipartFile.fromPath(
            entry.key,
            entry.value,
          );
          request.files.add(file);
        }
      }

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on SocketException {
      throw const ApiException('İnternet bağlantısı bulunamadı');
    } on HttpException {
      throw const ApiException('HTTP hatası oluştu');
    } catch (e) {
      throw ApiException('Beklenmedik hata: $e');
    }
  }

  /// HTTP yanıtını işler ve hataları kontrol eder
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      try {
        return json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw const ApiException('Geçersiz JSON yanıtı alındı');
      }
    }

    // Hata durumları
    String errorMessage;
    switch (statusCode) {
      case 400:
        errorMessage = 'Geçersiz istek';
        break;
      case 401:
        errorMessage = 'Yetkisiz erişim';
        break;
      case 403:
        errorMessage = 'Erişim engellendi';
        break;
      case 404:
        errorMessage = 'Kaynak bulunamadı';
        break;
      case 429:
        errorMessage = 'Çok fazla istek gönderildi. Lütfen bekleyin.';
        break;
      case 500:
        errorMessage = 'Sunucu hatası';
        break;
      default:
        errorMessage = 'HTTP Hatası: $statusCode';
    }

    // Sunucudan gelen hata mesajını almaya çalış
    try {
      final errorBody = json.decode(response.body) as Map<String, dynamic>;
      if (errorBody.containsKey('error')) {
        errorMessage = errorBody['error'] as String;
      } else if (errorBody.containsKey('message')) {
        errorMessage = errorBody['message'] as String;
      }
    } catch (_) {
      // JSON parse hatası durumunda varsayılan mesajı kullan
    }

    throw ApiException(errorMessage);
  }
}

/// API isteklerinde oluşabilecek hataları temsil eden exception sınıfı
class ApiException implements Exception {
  /// Hata mesajı
  final String message;

  const ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}

