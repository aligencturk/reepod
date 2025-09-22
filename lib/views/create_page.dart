import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../services/openai_service.dart';
import '../services/gemini_image_service.dart';
import '../services/image_save_service.dart';
import '../utils/logger_util.dart';

/// AI Foto Oluşturma Sayfası
/// iOS tarzında modern ve şık tasarım
class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _promptController = TextEditingController();
  final OpenAIService _openAIService = OpenAIService();
  final ImageSaveService _imageSaveService = ImageSaveService();
  GeminiImageService? _geminiImageService;
  String _selectedStyle = 'AI Maceracı';
  String _selectedModel = 'OpenAI DALL-E 3';
  bool _isGenerating = false;
  Uint8List? _generatedImage;

  @override
  void initState() {
    super.initState();
    _initializeGeminiService();
  }

  void _initializeGeminiService() {
    try {
      _geminiImageService = GeminiImageService.fromConfig();
      LoggerUtil.info('Gemini Image Service initialized successfully');
    } catch (e) {
      LoggerUtil.error('Gemini Image Service initialization failed', e);
      try {
        // Fallback to .env file directly
        _geminiImageService = GeminiImageService.fromEnv();
        LoggerUtil.info('Gemini Image Service initialized from .env file');
      } catch (e2) {
        LoggerUtil.error(
          'Failed to initialize Gemini Image Service from .env file',
          e2,
        );
        // Service will remain null, we'll handle this in the UI
      }
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    _openAIService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A)],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            _buildHeroSection(),

            const SizedBox(height: 40),

            // Prompt girişi
            _buildPromptSection(),

            const SizedBox(height: 24),

            // Stil seçimi
            _buildStyleSection(),

            const SizedBox(height: 32),

            // Oluştur butonu
            _buildCreateButton(),

            const SizedBox(height: 24),

            // Son oluşturulan görsel
            if (_generatedImage != null) ...[
              _buildLastGeneratedImage(),
              const SizedBox(height: 24),
            ],

            // Örnekler
            _buildExamplesSection(),

            const SizedBox(height: 100), // Bottom nav için boşluk
          ],
        ),
      ),
    );
  }

  /// Hero bölümü - Ana başlık ve açıklama
  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // AI Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.red, Color(0xFFE50914)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 40,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 24),

          // Başlık
          const Text(
            'AI Foto Oluşturucu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Alt başlık
          const Text(
            'Yapay zeka ile hayal gücünüzü gerçeğe dönüştürün',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Prompt girişi bölümü
  Widget _buildPromptSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit, color: Colors.red, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Prompt Girin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F0F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
            ),
            child: TextField(
              controller: _promptController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Hayal gücünüzü yazın...',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(20),
              ),
              maxLines: 4,
              textAlignVertical: TextAlignVertical.top,
            ),
          ),
        ],
      ),
    );
  }

  /// Stil seçimi bölümü
  Widget _buildStyleSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.palette, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Stil Seçin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Model Seçimi
          _buildModelSelector(),

          const SizedBox(height: 20),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              'AI Maceracı',
              'AI Fantastik',
              'AI Portre',
              'AI Bilim Kurgu',
              'AI Sanat',
              'AI Mimari',
            ].map((style) => _buildStyleChip(style)).toList(),
          ),
        ],
      ),
    );
  }

  /// Stil seçim chip'i
  Widget _buildStyleChip(String style) {
    final isSelected = _selectedStyle == style;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStyle = style;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(colors: [Colors.red, Color(0xFFE50914)])
              : null,
          color: isSelected ? null : const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          style,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[300],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  /// Oluştur butonu
  Widget _buildCreateButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: _isGenerating
            ? const LinearGradient(colors: [Colors.grey, Color(0xFF666666)])
            : const LinearGradient(colors: [Colors.red, Color(0xFFE50914)]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: (_isGenerating ? Colors.grey : Colors.red).withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: _isGenerating
              ? null
              : () {
                  _createImage();
                },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: _isGenerating
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 24,
                        ),
                ),
                const SizedBox(width: 16),
                Text(
                  _isGenerating ? 'Oluşturuluyor...' : 'AI ile Oluştur',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Son oluşturulan görseli göster
  Widget _buildLastGeneratedImage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Son Oluşturulan Görsel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(_generatedImage!, fit: BoxFit.cover),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showGeneratedImage(_generatedImage!);
                  },
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('Büyük Görüntüle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _saveImage(_generatedImage!);
                  },
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Kaydet'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Örnekler bölümü
  Widget _buildExamplesSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.yellow,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Örnek Promptlar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildExamplePrompts(),
        ],
      ),
    );
  }

  /// Örnek prompt listesi
  Widget _buildExamplePrompts() {
    final examples = [
      'Epik dağ manzarası, gün batımı',
      'Siberpunk şehir, neon ışıklar',
      'Büyülü orman, peri masalı',
      'Uzay istasyonu, bilim kurgu',
      'Portre, dijital sanat',
      'Modern mimari, cam binalar',
    ];

    return Column(
      children: examples
          .map(
            (example) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    _promptController.text = example;
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.yellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.lightbulb_outline,
                            color: Colors.yellow,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            example,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  /// AI ile görsel oluşturma işlemi
  Future<void> _createImage() async {
    if (_promptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir prompt girin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (mounted) {
      setState(() {
        _isGenerating = true;
      });
    }

    try {
      if (_selectedModel == 'OpenAI DALL-E 3') {
        // OpenAI API ile görsel oluştur
        final imageData = await _openAIService.generateImage(
          prompt: _promptController.text.trim(),
          style: _selectedStyle,
        );

        if (imageData != null) {
          if (mounted) {
            setState(() {
              _generatedImage = imageData;
            });

            // Başarılı oluşturma mesajı
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Görsel başarıyla oluşturuldu!'),
                backgroundColor: Colors.green,
              ),
            );

            // Görseli göster
            _showGeneratedImage(imageData);
          }
        } else {
          // Hata mesajı
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Görsel oluşturulurken bir hata oluştu. Lütfen tekrar deneyin.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else if (_selectedModel == 'Gemini 2.5 Flash') {
        // Gemini Image Service ile görsel oluştur
        if (_geminiImageService == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Gemini servisi başlatılamadı. Lütfen API anahtarını kontrol edin.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        final imageBytes = await _geminiImageService!.generateImage(
          prompt:
              '${_selectedStyle} tarzında: ${_promptController.text.trim()}',
          width: 1024,
          height: 1024,
        );

        if (mounted) {
          setState(() {
            _generatedImage = imageBytes;
          });

          // Başarılı oluşturma mesajı
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Görsel başarıyla oluşturuldu!'),
              backgroundColor: Colors.green,
            ),
          );

          // Görseli göster
          _showGeneratedImage(imageBytes);
        }
      }
    } catch (e) {
      LoggerUtil.error('Image generation error', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  /// Oluşturulan görseli göster
  void _showGeneratedImage(Uint8List imageData) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Başlık
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Oluşturulan Görsel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Görsel
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(imageData, fit: BoxFit.contain),
                  ),
                ),
              ),

              // Butonlar
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Görseli kaydet
                          _saveImage(imageData);
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Kaydet'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                        label: const Text('Kapat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Görseli kaydet
  Future<void> _saveImage(Uint8List imageData) async {
    try {
      // Loading göster
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Görseli galeriye kaydet
      final success = await _imageSaveService.saveToGallery(
        imageData: imageData,
        fileName: 'ai_generated_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      // Loading'i kapat
      Navigator.of(context).pop();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Görsel galeriye kaydedildi!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Görsel kaydedilemedi. İzin verilmedi olabilir.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Loading'i kapat
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Model seçici widget'ı
  Widget _buildModelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI Modeli Seçin',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedModel,
              isExpanded: true,
              dropdownColor: const Color(0xFF2D2D2D),
              style: const TextStyle(color: Colors.white),
              items: const [
                DropdownMenuItem(
                  value: 'OpenAI DALL-E 3',
                  child: Text('OpenAI DALL-E 3 (Yüksek Kalite)'),
                ),
                DropdownMenuItem(
                  value: 'Gemini 2.5 Flash',
                  child: Text('Gemini 2.5 Flash (Hızlı & Çoklu)'),
                ),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedModel = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
