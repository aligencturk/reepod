import 'package:flutter/material.dart';

/// iOS 26 tarzında uygulama renkleri
class AppColors {
  AppColors._();

  // MARK: - Primary Colors (iOS 26 System Colors)
  static const Color primary = Color(0xFF007AFF);
  static const Color primaryDark = Color(0xFF0051D5);
  static const Color primaryLight = Color(0xFF5AC8FA);

  // MARK: - Background Colors (Glassmorphism)
  static const Color backgroundPrimary = Color(0xFF000000);
  static const Color backgroundSecondary = Color(0xFF1C1C1E);
  static const Color backgroundTertiary = Color(0xFF2C2C2E);

  static const Color glassPrimary = Color(0x1AFFFFFF);
  static const Color glassSecondary = Color(0x0FFFFFFF);
  static const Color glassTertiary = Color(0x05FFFFFF);

  // MARK: - Surface Colors
  static const Color surface = Color(0xFF1C1C1E);
  static const Color surfaceVariant = Color(0xFF2C2C2E);
  static const Color surfaceContainer = Color(0xFF3A3A3C);

  // MARK: - Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0x99FFFFFF);
  static const Color textTertiary = Color(0x60FFFFFF);
  static const Color textQuaternary = Color(0x30FFFFFF);

  // MARK: - Accent Colors (Neon/Pastel)
  static const Color accent1 = Color(0xFFFF6B6B); // Coral Pink
  static const Color accent2 = Color(0xFF4ECDC4); // Teal
  static const Color accent3 = Color(0xFF45B7D1); // Sky Blue
  static const Color accent4 = Color(0xFF96CEB4); // Mint Green
  static const Color accent5 = Color(0xFFFECA57); // Golden Yellow
  static const Color accent6 = Color(0xFFFF9FF3); // Light Pink
  static const Color accent7 = Color(0xFF54A0FF); // Blue
  static const Color accent8 = Color(0xFF5F27CD); // Purple

  // MARK: - Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
  );

  static const LinearGradient tertiaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
  );

  // MARK: - Semantic Colors
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF007AFF);

  // MARK: - Interactive Colors
  static const Color interactive = Color(0xFF007AFF);
  static const Color interactivePressed = Color(0xFF0051D5);
  static const Color interactiveDisabled = Color(0xFF3A3A3C);

  // MARK: - Social Media Colors
  static const Color share = Color(0xFF4ECDC4);
  static const Color comment = Color(0xFF45B7D1);

  // MARK: - Card Colors
  static const Color cardBackground = Color(0x1AFFFFFF);
  static const Color cardBorder = Color(0x0FFFFFFF);
  static const Color cardShadow = Color(0x40000000);

  // MARK: - Loading Colors
  static const Color loadingPrimary = Color(0xFF007AFF);
  static const Color loadingSecondary = Color(0xFF5AC8FA);

  // MARK: - Helper Methods

  /// Renklerin opacity'sini ayarlar
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Glassmorphism efekti için renk döndürür
  static Color getGlassColor({
    Color baseColor = Colors.white,
    double opacity = 0.1,
  }) {
    return baseColor.withOpacity(opacity);
  }

  /// Gradient listesinden rastgele gradient seçer
  static LinearGradient getRandomGradient() {
    final gradients = [
      primaryGradient,
      secondaryGradient,
      tertiaryGradient,
      accentGradient,
    ];

    final random = DateTime.now().millisecondsSinceEpoch % gradients.length;
    return gradients[random];
  }

  /// Accent renklerinden rastgele renk seçer
  static Color getRandomAccentColor() {
    final colors = [
      accent1,
      accent2,
      accent3,
      accent4,
      accent5,
      accent6,
      accent7,
      accent8,
    ];

    final random = DateTime.now().millisecondsSinceEpoch % colors.length;
    return colors[random];
  }

  /// Metin kontrastına göre uygun text rengi döndürür
  static Color getTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
