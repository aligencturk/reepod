import 'api_service.dart';

/// AI görsel üretimi için servis sınıfı
class ImageGenService {
  // OpenAI DALL-E API endpoint (demo amaçlı)
  static const String _openaiBaseUrl = 'https://api.openai.com/v1/images/generations';
  
  // Stable Diffusion API endpoint (demo amaçlı)
  static const String _stableDiffusionUrl = 'https://api.stability.ai/v1/generation/stable-diffusion-xl-1024-v1-0/text-to-image';
  
  // Demo modda kullanılacak ücretsiz API (Unsplash)
  static const String _unsplashUrl = 'https://api.unsplash.com/photos/random';
  
  /// Belirtilen prompt ile görsel üretir
  /// 
  /// [prompt] - Görsel için açıklama metni
  /// [style] - Görsel stili (Realistik, Anime, Sanat vb.)
  /// [useDemo] - Demo modda çalışıp çalışmayacağı (gerçek AI API yerine placeholder)
  static Future<ImageGenerationResult> generateImage({
    required String prompt,
    required String style,
    bool useDemo = true,
  }) async {
    if (useDemo) {
      return _generateDemoImage(prompt, style);
    }
    
    // Gerçek AI API kullanımı için
    return _generateRealImage(prompt, style);
  }

  /// Demo modda görsel üretir (Unsplash API kullanarak)
  static Future<ImageGenerationResult> _generateDemoImage(
    String prompt,
    String style,
  ) async {
    try {
      // Prompt'tan anahtar kelimeler çıkar
      final keywords = _extractKeywords(prompt);
      
      final response = await ApiService.get(
        '$_unsplashUrl?query=$keywords&orientation=squarish',
        headers: {
          'Authorization': 'Client-ID YOUR_UNSPLASH_ACCESS_KEY', // Demo için
        },
      );

      final imageUrl = response['urls']['regular'] as String;
      
      // Simüle edilmiş gecikme (AI üretimi hissini verir)
      await Future.delayed(const Duration(seconds: 2));

      return ImageGenerationResult(
        imageUrl: imageUrl,
        prompt: prompt,
        style: style,
        isSuccess: true,
      );
    } catch (e) {
      // Hata durumunda placeholder görsel döndür
      return ImageGenerationResult(
        imageUrl: _getPlaceholderImage(prompt),
        prompt: prompt,
        style: style,
        isSuccess: false,
        error: 'Demo modda gerçek görsel alınamadı: $e',
      );
    }
  }

  /// Gerçek AI API ile görsel üretir
  static Future<ImageGenerationResult> _generateRealImage(
    String prompt,
    String style,
  ) async {
    try {
      // OpenAI DALL-E kullanımı örneği
      final response = await ApiService.post(
        _openaiBaseUrl,
        headers: {
          'Authorization': 'Bearer YOUR_OPENAI_API_KEY',
        },
        body: {
          'prompt': '$style tarzında: $prompt',
          'n': 1,
          'size': '1024x1024',
          'quality': 'standard',
        },
      );

      final imageUrl = response['data'][0]['url'] as String;

      return ImageGenerationResult(
        imageUrl: imageUrl,
        prompt: prompt,
        style: style,
        isSuccess: true,
      );
    } catch (e) {
      // Stable Diffusion API'yi dene
      return _tryStableDiffusion(prompt, style);
    }
  }

  /// Stable Diffusion API ile görsel üretmeyi dener
  static Future<ImageGenerationResult> _tryStableDiffusion(
    String prompt,
    String style,
  ) async {
    try {
      final response = await ApiService.post(
        _stableDiffusionUrl,
        headers: {
          'Authorization': 'Bearer YOUR_STABILITY_API_KEY',
        },
        body: {
          'text_prompts': [
            {
              'text': '$style style: $prompt',
              'weight': 1.0,
            }
          ],
          'cfg_scale': 7,
          'height': 1024,
          'width': 1024,
          'samples': 1,
          'steps': 30,
        },
      );

      // Base64 encoded image'ı URL'e çevir
      final base64Image = response['artifacts'][0]['base64'] as String;
      final imageUrl = _convertBase64ToUrl(base64Image);

      return ImageGenerationResult(
        imageUrl: imageUrl,
        prompt: prompt,
        style: style,
        isSuccess: true,
      );
    } catch (e) {
      return ImageGenerationResult(
        imageUrl: _getPlaceholderImage(prompt),
        prompt: prompt,
        style: style,
        isSuccess: false,
        error: 'Görsel üretilemedi: $e',
      );
    }
  }

  /// Prompt'tan anahtar kelimeler çıkarır
  static String _extractKeywords(String prompt) {
    // Basit keyword extraction
    final words = prompt.toLowerCase().split(' ');
    final keywords = words
        .where((word) => word.length > 3)
        .take(3)
        .join(',');
    return keywords.isEmpty ? 'abstract,art' : keywords;
  }

  /// Placeholder görsel URL'i döndürür
  static String _getPlaceholderImage(String prompt) {
    final hash = prompt.hashCode.abs();
    return 'https://picsum.photos/1024/1024?random=$hash';
  }

  /// Base64 encoded görsel verisini URL'e çevirir
  static String _convertBase64ToUrl(String base64Data) {
    // Gerçek uygulamada bu veriyi bir dosyaya kaydedip local URL döndürmeniz gerekir
    // Şimdilik placeholder döndürüyoruz
    return 'data:image/png;base64,$base64Data';
  }

  /// Mevcut görsel stillerini döndürür
  static List<String> getAvailableStyles() {
    return [
      'Realistik',
      'Anime',
      'Sanat',
      'Karikatür',
      'Minimalist',
      'Vintage',
      'Cyberpunk',
      'Fantasy',
    ];
  }
}

/// Görsel üretimi sonucunu temsil eden sınıf
class ImageGenerationResult {
  /// Üretilen görselin URL'i
  final String imageUrl;
  
  /// Kullanılan prompt
  final String prompt;
  
  /// Kullanılan stil
  final String style;
  
  /// Başarılı olup olmadığı
  final bool isSuccess;
  
  /// Hata mesajı (varsa)
  final String? error;

  const ImageGenerationResult({
    required this.imageUrl,
    required this.prompt,
    required this.style,
    required this.isSuccess,
    this.error,
  });

  @override
  String toString() {
    return 'ImageGenerationResult(imageUrl: $imageUrl, prompt: $prompt, style: $style, isSuccess: $isSuccess)';
  }
}
