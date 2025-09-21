import 'package:logger/logger.dart';

/// Uygulama genelinde kullanılacak logger utility sınıfı
class LoggerUtil {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Stack trace'de gösterilecek method sayısı
      errorMethodCount: 8, // Hata durumunda gösterilecek method sayısı
      lineLength: 120, // Log satır uzunluğu
      colors: true, // Renkli loglar
      printEmojis: true, // Emoji kullanımı
      printTime: true, // Zaman damgası
    ),
  );

  /// Debug seviyesinde log
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Info seviyesinde log
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Warning seviyesinde log
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Error seviyesinde log
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Fatal seviyesinde log
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// API çağrıları için özel log
  static void apiCall(
    String endpoint,
    String method, {
    Map<String, dynamic>? params,
  }) {
    _logger.i('API Call: $method $endpoint', error: params);
  }

  /// API yanıtları için özel log
  static void apiResponse(String endpoint, int statusCode, {dynamic response}) {
    if (statusCode >= 200 && statusCode < 300) {
      _logger.i('API Response: $endpoint - $statusCode', error: response);
    } else {
      _logger.e('API Error: $endpoint - $statusCode', error: response);
    }
  }

  /// Cache işlemleri için özel log
  static void cache(String operation, {dynamic data}) {
    _logger.d('Cache $operation', error: data);
  }

  /// UI işlemleri için özel log
  static void ui(String action, {dynamic data}) {
    _logger.d('UI $action', error: data);
  }
}
