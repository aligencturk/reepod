import 'package:flutter/foundation.dart';
import '../utils/logger_util.dart';

/// Tüm ViewModeller için temel sınıf
/// Loading, error ve success durumlarını yönetir
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isDisposed = false;
  String? _errorMessage;

  /// Loading durumunu döndürür
  bool get isLoading => _isLoading;

  /// Error mesajını döndürür
  String? get errorMessage => _errorMessage;

  /// Hata olup olmadığını kontrol eder
  bool get hasError => _errorMessage != null;

  /// Loading durumunu ayarlar
  void setLoading(bool loading) {
    if (_isDisposed) return;

    _isLoading = loading;
    notifyListeners();
  }

  /// Error mesajını ayarlar
  void setError(String? error) {
    if (_isDisposed) return;

    _errorMessage = error;
    notifyListeners();
  }

  /// Error'u temizler
  void clearError() {
    if (_isDisposed) return;

    _errorMessage = null;
    notifyListeners();
  }

  /// Loading ve error durumlarını temizler
  void clearState() {
    if (_isDisposed) return;

    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Asenkron işlemleri güvenli şekilde çalıştırır
  /// Loading durumunu otomatik yönetir ve hataları yakalar
  Future<T?> safeExecute<T>(
    Future<T> Function() operation, {
    String? errorPrefix,
    bool showLoading = true,
  }) async {
    if (_isDisposed) return null;

    try {
      if (showLoading) {
        setLoading(true);
      }
      clearError();

      final result = await operation();

      if (showLoading) {
        setLoading(false);
      }

      return result;
    } catch (e, stackTrace) {
      if (showLoading) {
        setLoading(false);
      }

      String errorMsg = errorPrefix != null
          ? '$errorPrefix: ${e.toString()}'
          : e.toString();

      setError(errorMsg);

      // Debug modda stack trace'i yazdır
      if (kDebugMode) {
        LoggerUtil.error('BaseViewModel Error: $errorMsg', null, stackTrace);
      }

      return null;
    }
  }

  /// ViewState enum değerlerini döndürür
  ViewState get viewState {
    if (_isLoading) return ViewState.loading;
    if (hasError) return ViewState.error;
    return ViewState.success;
  }

  /// Belirtilen süre sonra error mesajını otomatik temizler
  void clearErrorAfterDelay([Duration delay = const Duration(seconds: 5)]) {
    if (_isDisposed || !hasError) return;

    Future.delayed(delay, () {
      if (!_isDisposed) {
        clearError();
      }
    });
  }

  /// Success durumunda çağrılacak callback'i ayarlar
  void onSuccess(VoidCallback callback) {
    if (viewState == ViewState.success) {
      callback();
    }
  }

  /// Error durumunda çağrılacak callback'i ayarlar
  void onError(ValueChanged<String> callback) {
    if (hasError && _errorMessage != null) {
      callback(_errorMessage!);
    }
  }

  /// ViewModel dispose edildiğinde çağrılır
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Dispose edilmiş mi kontrol eder
  bool get isDisposed => _isDisposed;

  /// Debug için ViewState bilgisini string olarak döndürür
  String get debugViewState {
    switch (viewState) {
      case ViewState.loading:
        return 'Loading';
      case ViewState.error:
        return 'Error: $_errorMessage';
      case ViewState.success:
        return 'Success';
    }
  }
}

/// UI durumlarını temsil eden enum
enum ViewState {
  /// Yükleniyor durumu
  loading,

  /// Hata durumu
  error,

  /// Başarılı durum
  success,
}

/// ViewState extension metotları
extension ViewStateExtension on ViewState {
  /// Loading durumunda mı?
  bool get isLoading => this == ViewState.loading;

  /// Error durumunda mı?
  bool get isError => this == ViewState.error;

  /// Success durumunda mı?
  bool get isSuccess => this == ViewState.success;
}
