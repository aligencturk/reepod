import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/app_providers.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

/// Ana uygulama başlangıç noktası
void main() async {
  // Flutter binding'lerini başlat
  WidgetsFlutterBinding.ensureInitialized();

  // .env dosyasını yükle
  await dotenv.load(fileName: ".env");

  // Sistem UI overlay stilini ayarla
  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle);

  // Tercih edilen cihaz yönlerini ayarla
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Uygulamayı başlat
  runApp(const ReePodApp());
}

/// Ana uygulama widget'ı
class ReePodApp extends StatelessWidget {
  const ReePodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders.wrapWithProviders(
      child: MaterialApp.router(
        // Uygulama bilgileri
        title: 'ReePod - AI Image Generator',
        debugShowCheckedModeBanner: false,

        // Tema yapılandırması
        theme: AppTheme.theme,
        themeMode: ThemeMode.dark,

        // Router yapılandırması
        routerConfig: AppRoutes.router,

        // Localization (Türkçe desteği)
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('tr', 'TR'), // Türkçe
          Locale('en', 'US'), // İngilizce (fallback)
        ],

        // Builder - Global scaffold messenger vs. için
        builder: (context, child) {
          return MediaQuery(
            // Text scale factor'ı sınırla (accessibility)
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(
                (MediaQuery.of(context).textScaler.scale(1.0)).clamp(0.8, 1.2),
              ),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
