import 'dart:io';
import 'dart:typed_data';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

/// Görsel Kaydetme Servisi
/// Oluşturulan görselleri cihaza kaydetmek için kullanılır
class ImageSaveService {
  static final Logger _logger = Logger();

  /// Görseli galeriye kaydet
  /// [imageData] - Kaydedilecek görsel verisi
  /// [fileName] - Dosya adı (opsiyonel)
  Future<bool> saveToGallery({
    required Uint8List imageData,
    String? fileName,
  }) async {
    try {
      // İzin kontrolü
      final permission = await _requestStoragePermission();
      if (!permission) {
        _logger.e('Storage permission denied');
        return false;
      }

      // Dosya adı oluştur
      final name =
          fileName ??
          'ai_generated_${DateTime.now().millisecondsSinceEpoch}.png';

      _logger.i('Saving image to gallery: $name');
      _logger.i('Image size: ${imageData.length} bytes');

      // Geçici dosya oluştur
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$name');
      await tempFile.writeAsBytes(imageData);

      // Galeriye kaydet
      await Gal.putImage(tempFile.path);

      // Geçici dosyayı sil
      await tempFile.delete();

      _logger.i('Image saved successfully to gallery');
      return true;
    } catch (e) {
      _logger.e('Error saving image to gallery: $e');
      return false;
    }
  }

  /// Görseli uygulama dizinine kaydet
  /// [imageData] - Kaydedilecek görsel verisi
  /// [fileName] - Dosya adı (opsiyonel)
  Future<String?> saveToAppDirectory({
    required Uint8List imageData,
    String? fileName,
  }) async {
    try {
      // Uygulama dizinini al
      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${directory.path}/generated_images');

      // Dizin yoksa oluştur
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
        _logger.i('Created images directory: ${imagesDir.path}');
      }

      // Dosya adı oluştur
      final name =
          fileName ??
          'ai_generated_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${imagesDir.path}/$name');

      _logger.i('Saving image to app directory: ${file.path}');
      _logger.i('Image size: ${imageData.length} bytes');

      // Görseli kaydet
      await file.writeAsBytes(imageData);

      _logger.i('Image saved successfully to app directory');
      return file.path;
    } catch (e) {
      _logger.e('Error saving image to app directory: $e');
      return null;
    }
  }

  /// Depolama izni iste
  Future<bool> _requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        // 1) Klasik depolama izni (Android 12 ve öncesi için)
        final storage = await Permission.storage.request();
        if (storage.isGranted) {
          _logger.i('Storage permission granted');
          return true;
        }

        // 2) Android 13+ medya görselleri izni (plugin destekliyorsa)
        final photos = await Permission.photos.request();
        if (photos.isGranted) {
          _logger.i('Photos permission granted');
          return true;
        }

        _logger.w('Permissions denied. storage=$storage, photos=$photos');
        return false;
      }

      // iOS için photos permission
      if (Platform.isIOS) {
        final status = await Permission.photos.request();
        if (status.isGranted) {
          _logger.i('Photos permission granted');
          return true;
        } else {
          _logger.w('Photos permission denied: $status');
          return false;
        }
      }

      return true;
    } catch (e) {
      _logger.e('Error requesting storage permission: $e');
      return false;
    }
  }

  /// Kaydedilen görselleri listele
  Future<List<File>> getSavedImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${directory.path}/generated_images');

      if (!await imagesDir.exists()) {
        return [];
      }

      final files = await imagesDir.list().toList();
      final imageFiles = files
          .where((file) => file is File && _isImageFile(file.path))
          .cast<File>()
          .toList();

      // Tarihe göre sırala (en yeni önce)
      imageFiles.sort(
        (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
      );

      _logger.i('Found ${imageFiles.length} saved images');
      return imageFiles;
    } catch (e) {
      _logger.e('Error listing saved images: $e');
      return [];
    }
  }

  /// Dosyanın görsel dosyası olup olmadığını kontrol et
  bool _isImageFile(String path) {
    final extension = path.toLowerCase().split('.').last;
    return ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp'].contains(extension);
  }

  /// Görseli sil
  Future<bool> deleteImage(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        _logger.i('Image deleted: $filePath');
        return true;
      }
      return false;
    } catch (e) {
      _logger.e('Error deleting image: $e');
      return false;
    }
  }

  /// Tüm kaydedilen görselleri sil
  Future<bool> clearAllImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${directory.path}/generated_images');

      if (await imagesDir.exists()) {
        await imagesDir.delete(recursive: true);
        _logger.i('All images cleared');
        return true;
      }
      return true;
    } catch (e) {
      _logger.e('Error clearing all images: $e');
      return false;
    }
  }
}
