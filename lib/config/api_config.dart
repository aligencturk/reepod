/// API Configuration
/// Güvenlik için API anahtarlarını yönetir
class ApiConfig {
  // OpenAI API Key - Environment variable'dan alınır
  static String get openaiApiKey {
    const key = String.fromEnvironment('OPENAI_API_KEY');
    if (key.isEmpty) {
      // Development için fallback (production'da kaldırılmalı)
      throw Exception('OPENAI_API_KEY environment variable is not set. Please set it before running the app.');
    }
    return key;
  }
  
  // Google Gemini API Key - Environment variable'dan alınır
  static String get geminiApiKey {
    const key = String.fromEnvironment('AIzaSyBsZXi9at0b5HhKF5cprHBs6jXVDRChKpE');
    if (key.isEmpty) {
      throw Exception('GEMINI_API_KEY environment variable is not set. Please set it before running the app.');
    }
    return key;
  }
  
  // API Base URLs
  static const String openaiBaseUrl = 'https://api.openai.com/v1';
  
  // OpenAI Model configurations
  static const String defaultImageModel = 'dall-e-3';
  static const String fallbackImageModel = 'dall-e-2';
  static const String defaultImageSize = '1024x1024';
  static const String defaultImageQuality = 'hd';
  static const String defaultImageStyle = 'vivid';
  
  // Gemini Model configurations
  static const String geminiImageModel = 'gemini-2.5-flash-image-preview';
  static const String geminiTextModel = 'gemini-2.5-flash';
  static const String geminiVisionModel = 'gemini-2.5-flash-vision';
  
  // Request timeouts
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration imageDownloadTimeout = Duration(seconds: 60);
  
  // Rate limiting
  static const int maxRequestsPerMinute = 10;
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
}
