import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/card_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import '../theme/app_text_styles.dart';
import '../viewmodels/card_view_model.dart';
import '../services/clipboard_service.dart';
import 'loading_widget.dart';

/// 3D flip animasyonu ile çift taraflı kart widget'ı
class FlipCard extends StatefulWidget {
  /// Gösterilecek kart verisi (null ise yeni kart oluşturma modu)
  final CardItem? card;

  /// Kart tıklandığında çağrılacak callback
  final VoidCallback? onTap;

  /// Kartın boyutları
  final double? width;
  final double? height;

  /// Başlangıçta arka yüzü göster
  final bool startFlipped;

  const FlipCard({
    super.key,
    this.card,
    this.onTap,
    this.width,
    this.height,
    this.startFlipped = false,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isShowingFront = true;

  // Arka yüz için form kontrolleri
  final TextEditingController _promptController = TextEditingController();
  String _selectedStyle = AppConstants.imageStyles.first;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: AppConstants.flipAnimationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppConstants.flipAnimationCurve,
      ),
    );

    _isShowingFront = !widget.startFlipped;
    if (widget.startFlipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _promptController.dispose();
    super.dispose();
  }

  /// Kartı çevirir
  void _flipCard() {
    if (_controller.isAnimating) return;

    if (_isShowingFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    setState(() {
      _isShowingFront = !_isShowingFront;
    });

    widget.onTap?.call();
  }

  /// Yeni görsel üretir
  Future<void> _generateImage() async {
    if (_promptController.text.trim().isEmpty) {
      _showError('Lütfen bir prompt metni girin');
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final cardViewModel = context.read<CardViewModel>();

      final success = await cardViewModel.createCard(
        prompt: _promptController.text.trim(),
        style: _selectedStyle,
      );

      if (success) {
        // Başarılı olursa formu temizle ve kartı çevir
        _promptController.clear();
        _flipCard();
        _showSuccess('Görsel başarıyla üretildi!');
      } else {
        _showError(cardViewModel.errorMessage ?? 'Görsel üretilemedi');
      }
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  /// Başarı mesajı gösterir
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Hata mesajı gösterir
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = widget.width ?? AppConstants.cardWidth;
    final cardHeight = widget.height ?? AppConstants.cardHeight;

    return GestureDetector(
      onTap: widget.card != null ? _flipCard : null,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // 3D flip animasyon transform'u
          final isShowingFront = _animation.value < 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspektif efekti
              ..rotateY(_animation.value * 3.14159),
            child: Container(
              width: cardWidth,
              height: cardHeight,
              child: isShowingFront ? _buildFrontSide() : _buildBackSide(),
            ),
          );
        },
      ),
    );
  }

  /// Ön yüz - Görsel ve başlık
  Widget _buildFrontSide() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: double.infinity,
      borderRadius: AppConstants.cardBorderRadius,
      blur: AppConstants.glassBlur,
      alignment: Alignment.bottomCenter,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.glassPrimary, AppColors.glassSecondary],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.cardBorder, AppColors.cardBorder.withOpacity(0.5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Görsel alanı
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppConstants.cardBorderRadius),
              ),
              child: widget.card != null
                  ? _buildCardImage()
                  : _buildPlaceholderImage(),
            ),
          ),

          // Alt bilgi alanı
          Expanded(
            flex: 1,
            child: Padding(
              padding: AppConstants.paddingAll,
              child: widget.card != null
                  ? _buildCardInfo()
                  : _buildPlaceholderInfo(),
            ),
          ),
        ],
      ),
    );
  }

  /// Arka yüz - Prompt formu veya mevcut kart detayları
  Widget _buildBackSide() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: double.infinity,
      borderRadius: AppConstants.cardBorderRadius,
      blur: AppConstants.glassBlur,
      alignment: Alignment.bottomCenter,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.glassPrimary, AppColors.glassSecondary],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.cardBorder, AppColors.cardBorder.withOpacity(0.5)],
      ),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..rotateY(3.14159), // Metni düzelt
        child: Padding(
          padding: AppConstants.paddingAll,
          child: widget.card != null ? _buildCardDetails() : _buildCreateForm(),
        ),
      ),
    );
  }

  /// Mevcut kart detaylarını gösterir
  Widget _buildCardDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Başlık
        Text(
          'AI Prompt Detayları',
          style: AppTextStyles.cardTitle,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppConstants.marginLarge),

        // Prompt metni
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.cardBorder.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: SingleChildScrollView(
              child: Text(
                widget.card!.prompt,
                style: AppTextStyles.textField.copyWith(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppConstants.marginMedium),

        // Stil bilgisi
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accent3.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.palette, color: AppColors.accent3, size: 20),
              const SizedBox(width: 8),
              Text(
                'Stil: ${widget.card!.style}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.accent3,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.marginLarge),

        // Kopyala butonu
        SizedBox(
          height: AppConstants.buttonHeight,
          child: ElevatedButton.icon(
            onPressed: () => _copyPrompt(),
            icon: const Icon(Icons.copy),
            label: const Text('Prompt\'u Kopyala'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: AppConstants.marginMedium),

        // Geri dön butonu
        SizedBox(
          height: AppConstants.buttonHeight,
          child: OutlinedButton.icon(
            onPressed: _flipCard,
            icon: const Icon(Icons.flip),
            label: const Text('Geri Dön'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: BorderSide(color: AppColors.cardBorder),
            ),
          ),
        ),
      ],
    );
  }

  /// Yeni kart oluşturma formu
  Widget _buildCreateForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Başlık
        Text(
          'AI Görsel Üret',
          style: AppTextStyles.cardTitle,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppConstants.marginLarge),

        // Prompt text field
        Expanded(
          flex: 2,
          child: TextField(
            controller: _promptController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              hintText:
                  'Görsel açıklaması yazın...\nÖrnek: Gün batımında deniz kenarında koşan köpek',
              border: OutlineInputBorder(),
            ),
            style: AppTextStyles.textField,
          ),
        ),

        const SizedBox(height: AppConstants.marginMedium),

        // Stil seçimi
        DropdownButtonFormField<String>(
          value: _selectedStyle,
          decoration: const InputDecoration(
            labelText: 'Görsel Stili',
            border: OutlineInputBorder(),
          ),
          items: AppConstants.imageStyles
              .map(
                (style) =>
                    DropdownMenuItem<String>(value: style, child: Text(style)),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedStyle = value;
              });
            }
          },
          style: AppTextStyles.textField,
        ),

        const SizedBox(height: AppConstants.marginLarge),

        // Uygula butonu
        SizedBox(
          height: AppConstants.buttonHeight,
          child: ElevatedButton(
            onPressed: _isGenerating ? null : _generateImage,
            child: _isGenerating
                ? const LoadingWidget(size: 20)
                : const Text('Uygula'),
          ),
        ),
      ],
    );
  }

  /// Prompt'u panoya kopyalar
  void _copyPrompt() {
    if (widget.card != null) {
      ClipboardService.copyToClipboard(
        widget.card!.prompt,
        successMessage: 'Prompt panoya kopyalandı!',
      );
    }
  }

  /// Kart görseli widget'ı
  Widget _buildCardImage() {
    return CachedNetworkImage(
      imageUrl: widget.card!.imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColors.surfaceVariant,
        child: const Center(child: LoadingWidget()),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.surfaceVariant,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.broken_image,
              size: AppConstants.iconSizeLarge,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppConstants.marginSmall),
            Text('Görsel yüklenemedi', style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }

  /// Placeholder görsel widget'ı
  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.primaryGradient),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate,
            size: AppConstants.iconSizeXLarge,
            color: AppColors.textPrimary.withOpacity(0.7),
          ),
          const SizedBox(height: AppConstants.marginSmall),
          Text(
            'Yeni Görsel',
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.textPrimary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Kart bilgileri widget'ı
  Widget _buildCardInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Prompt metni
        Text(
          widget.card!.prompt,
          style: AppTextStyles.cardBody,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: AppConstants.marginSmall),

        // Alt bilgiler (stil)
        Row(
          children: [
            // Stil
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingSmall,
                vertical: AppConstants.paddingXSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.accent3.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Text(
                widget.card!.style,
                style: AppTextStyles.caption.copyWith(color: AppColors.accent3),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Placeholder bilgileri widget'ı
  Widget _buildPlaceholderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Dokunarak başlayın',
          style: AppTextStyles.cardSubtitle.copyWith(
            color: AppColors.textPrimary.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
