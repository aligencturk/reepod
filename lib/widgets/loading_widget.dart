import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import '../theme/app_text_styles.dart';

/// iOS 26 tarzında loading widget'ı
class LoadingWidget extends StatelessWidget {
  /// Loading animasyonunun boyutu
  final double size;
  
  /// Loading mesajı (opsiyonel)
  final String? message;
  
  /// Loading rengi
  final Color? color;
  
  /// Loading tipi
  final LoadingType type;

  const LoadingWidget({
    super.key,
    this.size = 50.0,
    this.message,
    this.color,
    this.type = LoadingType.pulse,
  });

  /// Küçük loading widget'ı (butonlar için)
  const LoadingWidget.small({
    super.key,
    this.message,
    this.color,
    this.type = LoadingType.pulse,
  }) : size = 20.0;

  /// Büyük loading widget'ı (tam ekran için)
  const LoadingWidget.large({
    super.key,
    this.message,
    this.color,
    this.type = LoadingType.wave,
  }) : size = 80.0;

  @override
  Widget build(BuildContext context) {
    final loadingColor = color ?? AppColors.primary;

    Widget loadingWidget;

    switch (type) {
      case LoadingType.pulse:
        loadingWidget = SpinKitPulse(
          color: loadingColor,
          size: size,
          duration: AppConstants.loadingAnimationDuration,
        );
        break;
      case LoadingType.wave:
        loadingWidget = SpinKitWave(
          color: loadingColor,
          size: size,
          duration: AppConstants.loadingAnimationDuration,
        );
        break;
      case LoadingType.fadingCircle:
        loadingWidget = SpinKitFadingCircle(
          color: loadingColor,
          size: size,
          duration: AppConstants.loadingAnimationDuration,
        );
        break;
      case LoadingType.threeBounce:
        loadingWidget = SpinKitThreeBounce(
          color: loadingColor,
          size: size * 0.3, // ThreeBounce için boyutu küçült
          duration: AppConstants.loadingAnimationDuration,
        );
        break;
      case LoadingType.wanderingCubes:
        loadingWidget = SpinKitWanderingCubes(
          color: loadingColor,
          size: size,
          duration: AppConstants.loadingAnimationDuration,
        );
        break;
      case LoadingType.circle:
        loadingWidget = SpinKitCircle(
          color: loadingColor,
          size: size,
          duration: AppConstants.loadingAnimationDuration,
        );
        break;
    }

    if (message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loadingWidget,
          const SizedBox(height: AppConstants.marginMedium),
          Text(
            message!,
            style: AppTextStyles.bodyText2.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return loadingWidget;
  }
}

/// Tam ekran loading overlay widget'ı
class LoadingOverlay extends StatelessWidget {
  /// Loading gösterilip gösterilmeyeceği
  final bool isLoading;
  
  /// Ana içerik widget'ı
  final Widget child;
  
  /// Loading mesajı
  final String? message;
  
  /// Loading rengi
  final Color? color;
  
  /// Overlay rengi
  final Color? overlayColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.color,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? AppColors.backgroundPrimary.withOpacity(0.7),
            child: Center(
              child: LoadingWidget.large(
                message: message,
                color: color,
              ),
            ),
          ),
      ],
    );
  }
}

/// Glassmorphism loading widget'ı
class GlassLoadingWidget extends StatelessWidget {
  /// Loading animasyonunun boyutu
  final double size;
  
  /// Loading mesajı
  final String? message;
  
  /// Loading rengi
  final Color? color;

  const GlassLoadingWidget({
    super.key,
    this.size = 50.0,
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppConstants.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.glassPrimary,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: AppConstants.shadowMedium,
      ),
      child: LoadingWidget(
        size: size,
        message: message,
        color: color,
        type: LoadingType.fadingCircle,
      ),
    );
  }
}

/// Shimmer loading effect widget'ı
class ShimmerLoading extends StatefulWidget {
  /// Widget'ın genişliği
  final double width;
  
  /// Widget'ın yüksekliği
  final double height;
  
  /// Border radius
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppConstants.radiusMedium,
  });

  /// Kart shimmer'ı
  const ShimmerLoading.card({
    super.key,
    this.borderRadius = AppConstants.cardBorderRadius,
  }) : width = AppConstants.cardWidth,
       height = AppConstants.cardHeight;

  /// List item shimmer'ı
  const ShimmerLoading.listItem({
    super.key,
    this.borderRadius = AppConstants.radiusMedium,
  }) : width = double.infinity,
       height = AppConstants.listItemHeight;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.loadingAnimationDuration,
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                (_animation.value - 1).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1).clamp(0.0, 1.0),
              ],
              colors: [
                AppColors.surfaceVariant,
                AppColors.surfaceContainer,
                AppColors.surfaceVariant,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Loading durumları için error widget'ı
class ErrorWidget extends StatelessWidget {
  /// Hata mesajı
  final String message;
  
  /// Tekrar dene callback'i
  final VoidCallback? onRetry;
  
  /// Icon
  final IconData icon;

  const ErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppConstants.iconSizeXLarge,
            color: AppColors.error,
          ),
          
          const SizedBox(height: AppConstants.marginMedium),
          
          Text(
            message,
            style: AppTextStyles.bodyText1.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          if (onRetry != null) ...[
            const SizedBox(height: AppConstants.marginLarge),
            
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading tiplerini belirten enum
enum LoadingType {
  /// Pulse animasyonu
  pulse,
  
  /// Dalga animasyonu
  wave,
  
  /// Kaybolup beliren çember
  fadingCircle,
  
  /// Üç zıplayan nokta
  threeBounce,
  
  /// Dolaşan küpler
  wanderingCubes,
  
  /// Dönen çember
  circle,
}

