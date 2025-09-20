import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan sabitler
class AppConstants {
  AppConstants._();

  // MARK: - Layout Constants
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double marginXSmall = 4.0;
  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;
  static const double marginXLarge = 32.0;

  // MARK: - Border Radius Constants
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusCircle = 50.0;

  // MARK: - Card Constants
  static const double cardElevation = 8.0;
  static const double cardBorderRadius = 20.0;
  static const double cardPadding = 16.0;
  static const double cardMargin = 8.0;
  
  // Card dimensions
  static const double cardWidth = 300.0;
  static const double cardHeight = 400.0;
  static const double cardImageHeight = 200.0;

  // MARK: - Animation Constants
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);
  static const Duration animationDurationExtraSlow = Duration(milliseconds: 800);

  // Flip animation
  static const Duration flipAnimationDuration = Duration(milliseconds: 600);
  static const Curve flipAnimationCurve = Curves.easeInOut;

  // Loading animation
  static const Duration loadingAnimationDuration = Duration(milliseconds: 1200);

  // MARK: - Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // MARK: - Button Constants
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightLarge = 56.0;
  static const double buttonBorderRadius = 16.0;
  
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: paddingLarge,
    vertical: paddingMedium,
  );

  // MARK: - Text Field Constants
  static const double textFieldHeight = 48.0;
  static const double textFieldBorderRadius = 16.0;
  static const EdgeInsets textFieldPadding = EdgeInsets.symmetric(
    horizontal: paddingMedium,
    vertical: paddingMedium,
  );

  // MARK: - AppBar Constants
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0;

  // MARK: - Bottom Sheet Constants
  static const double bottomSheetMaxHeight = 0.9;
  static const double bottomSheetBorderRadius = 20.0;

  // MARK: - Glassmorphism Constants
  static const double glassBlur = 20.0;
  static const double glassOpacity = 0.1;
  static const double glassBorderOpacity = 0.05;

  // MARK: - Shadow Constants
  static const double shadowBlurRadius = 20.0;
  static const double shadowSpreadRadius = 0.0;
  static const Offset shadowOffset = Offset(0, 8);

  // MARK: - Grid Constants
  static const double gridSpacing = 16.0;
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 0.75;

  // MARK: - List Constants
  static const double listItemHeight = 72.0;
  static const double listItemSpacing = 8.0;

  // MARK: - Breakpoints (Responsive)
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  // MARK: - Image Constants
  static const double imageQuality = 80.0;
  static const int imageCacheSize = 100;
  
  // Placeholder images
  static const String placeholderImageUrl = 'https://picsum.photos/400/400';
  static const String errorImageUrl = 'https://picsum.photos/400/400?blur=5';

  // MARK: - API Constants
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int apiRetryCount = 3;
  static const Duration apiRetryDelay = Duration(seconds: 2);

  // MARK: - Cache Constants
  static const Duration cacheMaxAge = Duration(hours: 24);
  static const int maxCachedCards = 50;

  // MARK: - Social Constants
  static const int maxCommentLength = 500;
  static const int maxPromptLength = 200;

  // MARK: - Style Options
  static const List<String> imageStyles = [
    'Realistik',
    'Anime',
    'Sanat',
    'Karikatür',
    'Minimalist',
    'Vintage',
    'Cyberpunk',
    'Fantasy',
  ];

  // MARK: - Edge Insets Presets
  static const EdgeInsets paddingAll = EdgeInsets.all(paddingMedium);
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(
    horizontal: paddingMedium,
  );
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(
    vertical: paddingMedium,
  );

  static const EdgeInsets marginAll = EdgeInsets.all(marginMedium);
  static const EdgeInsets marginHorizontal = EdgeInsets.symmetric(
    horizontal: marginMedium,
  );
  static const EdgeInsets marginVertical = EdgeInsets.symmetric(
    vertical: marginMedium,
  );

  // MARK: - Border Radius Presets
  static const BorderRadius borderRadiusSmall = BorderRadius.all(
    Radius.circular(radiusSmall),
  );
  static const BorderRadius borderRadiusMedium = BorderRadius.all(
    Radius.circular(radiusMedium),
  );
  static const BorderRadius borderRadiusLarge = BorderRadius.all(
    Radius.circular(radiusLarge),
  );
  static const BorderRadius borderRadiusXLarge = BorderRadius.all(
    Radius.circular(radiusXLarge),
  );

  // Top rounded corners
  static const BorderRadius borderRadiusTopMedium = BorderRadius.vertical(
    top: Radius.circular(radiusMedium),
  );
  static const BorderRadius borderRadiusTopLarge = BorderRadius.vertical(
    top: Radius.circular(radiusLarge),
  );

  // MARK: - Box Shadow Presets
  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 8.0,
      spreadRadius: 0.0,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 16.0,
      spreadRadius: 0.0,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: shadowBlurRadius,
      spreadRadius: shadowSpreadRadius,
      offset: shadowOffset,
    ),
  ];

  // Glassmorphism shadow
  static const List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Color(0x20FFFFFF),
      blurRadius: 20.0,
      spreadRadius: 0.0,
      offset: Offset(0, 8),
    ),
  ];

  // MARK: - Helper Methods
  
  /// Ekran boyutuna göre responsive değer döndürür
  static double getResponsiveValue(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= desktopBreakpoint) {
      return desktop;
    } else if (width >= tabletBreakpoint) {
      return tablet;
    } else {
      return mobile;
    }
  }

  /// Ekran türünü döndürür
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= desktopBreakpoint) {
      return ScreenType.desktop;
    } else if (width >= tabletBreakpoint) {
      return ScreenType.tablet;
    } else {
      return ScreenType.mobile;
    }
  }

  /// Grid column sayısını responsive olarak döndürür
  static int getGridColumnCount(BuildContext context) {
    final screenType = getScreenType(context);
    
    switch (screenType) {
      case ScreenType.desktop:
        return 4;
      case ScreenType.tablet:
        return 3;
      case ScreenType.mobile:
        return 2;
    }
  }
}

/// Ekran türleri enum'u
enum ScreenType {
  mobile,
  tablet,
  desktop,
}

