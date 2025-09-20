import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/card_view_model.dart';

/// Uygulama genelinde kullanılacak provider yapılandırması
class AppProviders {
  AppProviders._();

  /// Tüm provider'ları içeren MultiProvider widget'ı döndürür
  static Widget wrapWithProviders({
    required Widget child,
  }) {
    return MultiProvider(
      providers: _getProviders(),
      child: child,
    );
  }

  /// Provider listesini döndürür
  static List<ChangeNotifierProvider> _getProviders() {
    return [
      // CardViewModel provider'ı
      ChangeNotifierProvider<CardViewModel>(
        create: (context) => CardViewModel(),
        lazy: false, // Uygulama başlarken oluştur
      ),
      
      // Gelecekte eklenecek diğer ViewModeller
      /*
      ChangeNotifierProvider<UserViewModel>(
        create: (context) => UserViewModel(),
        lazy: true,
      ),
      
      ChangeNotifierProvider<SettingsViewModel>(
        create: (context) => SettingsViewModel(),
        lazy: true,
      ),
      
      ChangeNotifierProvider<ThemeViewModel>(
        create: (context) => ThemeViewModel(),
        lazy: true,
      ),
      */
    ];
  }

  /// Belirli bir provider'ı context'ten alır
  static T getProvider<T>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }

  /// Provider'ı dinleyerek alır
  static T watchProvider<T>(BuildContext context) {
    return context.watch<T>();
  }

  /// Provider'ı okur (bir kerelik)
  static T readProvider<T>(BuildContext context) {
    return context.read<T>();
  }
}

/// Provider extension'ları
extension ProviderExtensions on BuildContext {
  /// CardViewModel'i döndürür
  CardViewModel get cardViewModel => read<CardViewModel>();
  
  /// CardViewModel'i dinler
  CardViewModel get watchCardViewModel => watch<CardViewModel>();
  
  // Gelecekte eklenecek diğer ViewModeller için extension'lar
  /*
  UserViewModel get userViewModel => read<UserViewModel>();
  UserViewModel get watchUserViewModel => watch<UserViewModel>();
  
  SettingsViewModel get settingsViewModel => read<SettingsViewModel>();
  SettingsViewModel get watchSettingsViewModel => watch<SettingsViewModel>();
  
  ThemeViewModel get themeViewModel => read<ThemeViewModel>();
  ThemeViewModel get watchThemeViewModel => watch<ThemeViewModel>();
  */
}

/// Provider yardımcı metotları
class ProviderHelper {
  ProviderHelper._();

  /// Tüm provider'ları dispose eder (uygulama kapanırken)
  static void disposeProviders(BuildContext context) {
    try {
      // Manuel dispose işlemleri burada yapılabilir
      // Provider otomatik olarak dispose eder, ama özel durumlar için
    } catch (e) {
      debugPrint('Provider dispose error: $e');
    }
  }

  /// Provider durumlarını sıfırlar
  static void resetProviders(BuildContext context) {
    try {
      final cardViewModel = context.read<CardViewModel>();
      cardViewModel.clearState();
      // Diğer ViewModeller için de reset işlemleri
    } catch (e) {
      debugPrint('Provider reset error: $e');
    }
  }

  /// Tüm provider'ların yüklenmesini bekler
  static Future<void> initializeProviders(BuildContext context) async {
    try {
      // CardViewModel'i başlat
      final cardViewModel = context.read<CardViewModel>();
      await cardViewModel.loadCards();
      
      // Diğer ViewModeller için de initialization işlemleri
      
    } catch (e) {
      debugPrint('Provider initialization error: $e');
    }
  }

  /// Provider durumlarını loglar (debug amaçlı)
  static void logProviderStates(BuildContext context) {
    if (kDebugMode) {
      try {
        final cardViewModel = context.read<CardViewModel>();
        debugPrint('CardViewModel State: ${cardViewModel.debugViewState}');
        debugPrint('Cards Count: ${cardViewModel.cardCount}');
        
        // Diğer ViewModeller için de log işlemleri
        
      } catch (e) {
        debugPrint('Provider logging error: $e');
      }
    }
  }
}

/// Provider state sınıfı (global durumlar için)
class AppState extends ChangeNotifier {
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _globalError;

  /// Uygulama başlatılmış mı?
  bool get isInitialized => _isInitialized;

  /// Uygulama yükleniyor mu?
  bool get isLoading => _isLoading;

  /// Global hata mesajı
  String? get globalError => _globalError;

  /// Başlatma durumunu ayarlar
  void setInitialized(bool value) {
    _isInitialized = value;
    notifyListeners();
  }

  /// Loading durumunu ayarlar
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Global hata ayarlar
  void setGlobalError(String? error) {
    _globalError = error;
    notifyListeners();
  }

  /// Global hata temizler
  void clearGlobalError() {
    _globalError = null;
    notifyListeners();
  }

  /// Tüm durumları sıfırlar
  void reset() {
    _isInitialized = false;
    _isLoading = false;
    _globalError = null;
    notifyListeners();
  }
}

/// kDebugMode import'u için
bool get kDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

