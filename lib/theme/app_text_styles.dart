import 'package:flutter/material.dart';
import 'app_colors.dart';

/// iOS 26 tarzında text stilleri (SF Pro Font hissi)
class AppTextStyles {
  AppTextStyles._();

  // MARK: - Font Family
  static const String _fontFamily = 'SF Pro Display'; // iOS'ta varsayılan font

  // MARK: - Base Text Styles
  static const TextStyle _baseTextStyle = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.2,
  );

  // MARK: - Headlines
  static final TextStyle headline1 = _baseTextStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static final TextStyle headline2 = _baseTextStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    height: 1.1,
  );

  static final TextStyle headline3 = _baseTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static final TextStyle headline4 = _baseTextStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static final TextStyle headline5 = _baseTextStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.2,
  );

  static final TextStyle headline6 = _baseTextStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  // MARK: - Body Text
  static final TextStyle bodyText1 = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.4,
  );

  static final TextStyle bodyText2 = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.4,
  );

  // MARK: - Captions and Labels
  static final TextStyle caption = _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.3,
    color: AppColors.textTertiary,
  );

  static final TextStyle overline = _baseTextStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.6,
    color: AppColors.textTertiary,
  );

  // MARK: - Interactive Elements
  static final TextStyle button = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.2,
  );

  static final TextStyle buttonSmall = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.2,
  );

  static final TextStyle link = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
    height: 1.4,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  // MARK: - Specialized Styles
  static final TextStyle cardTitle = _baseTextStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static final TextStyle cardSubtitle = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static final TextStyle cardBody = _baseTextStyle.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static final TextStyle prompt = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.4,
    fontStyle: FontStyle.italic,
  );

  static final TextStyle timestamp = _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.3,
    color: AppColors.textTertiary,
  );

  static final TextStyle stats = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.2,
    color: AppColors.textSecondary,
  );

  // MARK: - Error and Success Styles
  static final TextStyle error = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
    height: 1.4,
    color: AppColors.error,
  );

  static final TextStyle success = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
    height: 1.4,
    color: AppColors.success,
  );

  static final TextStyle warning = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
    height: 1.4,
    color: AppColors.warning,
  );

  // MARK: - TextField Styles
  static final TextStyle textField = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.4,
  );

  static final TextStyle textFieldLabel = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
    height: 1.2,
    color: AppColors.textSecondary,
  );

  static final TextStyle textFieldHint = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.4,
    color: AppColors.textTertiary,
  );

  // MARK: - Navigation Styles
  static final TextStyle navTitle = _baseTextStyle.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static final TextStyle navSubtitle = _baseTextStyle.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // MARK: - Complete TextTheme
  static final TextTheme textTheme = TextTheme(
    displayLarge: headline1,
    displayMedium: headline2,
    displaySmall: headline3,
    headlineLarge: headline4,
    headlineMedium: headline5,
    headlineSmall: headline6,
    titleLarge: headline6,
    titleMedium: cardTitle,
    titleSmall: cardSubtitle,
    bodyLarge: bodyText1,
    bodyMedium: bodyText2,
    bodySmall: caption,
    labelLarge: button,
    labelMedium: buttonSmall,
    labelSmall: overline,
  );

  // MARK: - Helper Methods
  
  /// Gradient text style oluşturur
  static TextStyle createGradientStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Gradient gradient,
    double letterSpacing = -0.1,
    double height = 1.4,
  }) {
    return _baseTextStyle.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      // Gradient için shader mask kullanılacak
      foreground: Paint()..shader = gradient.createShader(
        const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
      ),
    );
  }

  /// Belirli bir renk ile text style oluşturur
  static TextStyle withColor(TextStyle baseStyle, Color color) {
    return baseStyle.copyWith(color: color);
  }

  /// Belirli bir font weight ile text style oluşturur
  static TextStyle withWeight(TextStyle baseStyle, FontWeight weight) {
    return baseStyle.copyWith(fontWeight: weight);
  }

  /// Responsive font size hesaplar
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 414) {
      return baseFontSize * 1.1; // Büyük ekranlar
    } else if (screenWidth < 375) {
      return baseFontSize * 0.9; // Küçük ekranlar
    }
    return baseFontSize; // Orta ekranlar
  }
}

