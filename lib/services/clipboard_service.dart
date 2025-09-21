import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Pano işlemleri için servis sınıfı
class ClipboardService {
  /// Metni panoya kopyalar ve kullanıcıya bildirim gösterir
  static Future<void> copyToClipboard(
    String text, {
    String? successMessage,
  }) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));

      // Başarı mesajı göster
      Fluttertoast.showToast(
        msg: successMessage ?? 'Panoya kopyalandı',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      // Hata mesajı göster
      Fluttertoast.showToast(
        msg: 'Kopyalama başarısız',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
