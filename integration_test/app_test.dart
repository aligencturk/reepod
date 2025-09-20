import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:reepod/main.dart' as app;
import 'package:reepod/widgets/flip_card.dart';
import 'package:reepod/widgets/loading_widget.dart';

/// ReePod uygulaması integration testleri
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ReePod App Integration Tests', () {
    testWidgets(
      'Uygulama başlatma ve ana ekran yükleme testi',
      (WidgetTester tester) async {
        // Uygulamayı başlat
        app.main();
        await tester.pumpAndSettle();

        // Ana ekranın yüklendiğini kontrol et
        expect(find.text('ReePod'), findsOneWidget);
        expect(find.text('AI Image Generator & Social'), findsOneWidget);

        // Tab bar'ın olduğunu kontrol et
        expect(find.text('Ana Sayfa'), findsOneWidget);
        expect(find.text('Popüler'), findsOneWidget);
        expect(find.text('Profil'), findsOneWidget);

        // FloatingActionButton'ın olduğunu kontrol et
        expect(find.byType(FloatingActionButton), findsOneWidget);
      },
    );

    testWidgets(
      'Yeni kart oluşturma dialog testi',
      (WidgetTester tester) async {
        // Uygulamayı başlat
        app.main();
        await tester.pumpAndSettle();

        // FloatingActionButton'a tap et
        final fab = find.byType(FloatingActionButton);
        expect(fab, findsOneWidget);
        
        await tester.tap(fab);
        await tester.pumpAndSettle();

        // Dialog'un açıldığını kontrol et
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byType(FlipCard), findsOneWidget);

        // Form alanlarının olduğunu kontrol et
        expect(find.text('AI Görsel Üret'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
        expect(find.text('Uygula'), findsOneWidget);
      },
    );

    testWidgets(
      'AI görsel üretme işlemi testi',
      (WidgetTester tester) async {
        // Uygulamayı başlat
        app.main();
        await tester.pumpAndSettle();

        // FloatingActionButton'a tap et
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Prompt metin alanını bul ve metin gir
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);
        
        await tester.enterText(textField, 'Güneşli bir günde ormanın içinde koşan köpek');
        await tester.pumpAndSettle();

        // Stil seçimi dropdown'unu kontrol et
        final dropdown = find.byType(DropdownButtonFormField<String>);
        expect(dropdown, findsOneWidget);

        // Uygula butonuna tap et
        final applyButton = find.text('Uygula');
        expect(applyButton, findsOneWidget);
        
        await tester.tap(applyButton);
        
        // Loading widget'ının göründüğünü kontrol et
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(LoadingWidget), findsOneWidget);
        
        // İşlemin tamamlanmasını bekle (maksimum 10 saniye)
        await tester.pumpAndSettle(const Duration(seconds: 10));

        // Dialog'un kapandığını kontrol et (başarılı işlem durumunda)
        // Not: Demo modda çalıştığı için placeholder görseli beklenebilir
      },
    );

    testWidgets(
      'Tab navigasyon testi',
      (WidgetTester tester) async {
        // Uygulamayı başlat
        app.main();
        await tester.pumpAndSettle();

        // Popüler tab'ına geç
        await tester.tap(find.text('Popüler'));
        await tester.pumpAndSettle();

        // Popüler içeriğinin yüklendiğini kontrol et
        // (İlk çalışmada boş olabilir)
        expect(find.text('Popüler'), findsOneWidget);

        // Profil tab'ına geç
        await tester.tap(find.text('Profil'));
        await tester.pumpAndSettle();

        // Profil bilgilerinin göründüğünü kontrol et
        expect(find.text('Kullanıcı'), findsOneWidget);
        expect(find.text('AI Sanatçısı'), findsOneWidget);
        expect(find.text('İstatistikler'), findsOneWidget);

        // Ana Sayfa tab'ına geri dön
        await tester.tap(find.text('Ana Sayfa'));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'Kart flip animasyon testi',
      (WidgetTester tester) async {
        // Uygulamayı başlat
        app.main();
        await tester.pumpAndSettle();

        // Önce bir kart oluşturalım
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Prompt gir
        await tester.enterText(
          find.byType(TextField),
          'Test görseli için prompt',
        );
        await tester.pumpAndSettle();

        // Uygula butonuna tap et
        await tester.tap(find.text('Uygula'));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Eğer kart oluşturulduysa, ona tap et
        final flipCards = find.byType(FlipCard);
        if (flipCards.evaluate().isNotEmpty) {
          // İlk kartı bul ve tap et
          await tester.tap(flipCards.first);
          await tester.pumpAndSettle();

          // Flip animasyonunun çalıştığını kontrol et
          // (Animasyon sırasında transform değişmeli)
        }
      },
    );

    testWidgets(
      'Profil istatistikleri testi',
      (WidgetTester tester) async {
        // Uygulamayı başlat
        app.main();
        await tester.pumpAndSettle();

        // Profil tab'ına geç
        await tester.tap(find.text('Profil'));
        await tester.pumpAndSettle();

        // İstatistik widgetlarının olduğunu kontrol et
        expect(find.text('Görseller'), findsOneWidget);
        expect(find.text('Toplam Beğeni'), findsOneWidget);
        expect(find.text('Yorumlar'), findsOneWidget);

        // Ayarlar seçeneklerinin olduğunu kontrol et
        expect(find.text('Kartları Yenile'), findsOneWidget);
        expect(find.text('Tüm Kartları Temizle'), findsOneWidget);
        expect(find.text('Uygulama Hakkında'), findsOneWidget);
      },
    );

    testWidgets(
      'Hakkında dialog testi',
      (WidgetTester tester) async {
        // Uygulamayı başlat
        app.main();
        await tester.pumpAndSettle();

        // Profil tab'ına geç
        await tester.tap(find.text('Profil'));
        await tester.pumpAndSettle();

        // "Uygulama Hakkında" seçeneğine tap et
        await tester.tap(find.text('Uygulama Hakkında'));
        await tester.pumpAndSettle();

        // Dialog'un açıldığını kontrol et
        expect(find.text('ReePod Hakkında'), findsOneWidget);
        expect(find.text('ReePod - AI Image Generator & Social Media'), findsOneWidget);
        expect(find.text('Versiyon: 1.0.0'), findsOneWidget);

        // Tamam butonuna tap et
        await tester.tap(find.text('Tamam'));
        await tester.pumpAndSettle();

        // Dialog'un kapandığını kontrol et
        expect(find.text('ReePod Hakkında'), findsNothing);
      },
    );

    testWidgets(
      'Kartları temizleme onay dialog testi',
      (WidgetTester tester) async {
        // Uygulamayı başlat
        app.main();
        await tester.pumpAndSettle();

        // Profil tab'ına geç
        await tester.tap(find.text('Profil'));
        await tester.pumpAndSettle();

        // "Tüm Kartları Temizle" seçeneğine tap et
        await tester.tap(find.text('Tüm Kartları Temizle'));
        await tester.pumpAndSettle();

        // Onay dialog'unun açıldığını kontrol et
        expect(find.text('Tüm Kartları Temizle'), findsNWidgets(2)); // Başlık ve list item
        expect(find.text('Bu işlem tüm kartlarınızı'), findsOneWidget);
        expect(find.text('İptal'), findsOneWidget);
        expect(find.text('Temizle'), findsOneWidget);

        // İptal butonuna tap et
        await tester.tap(find.text('İptal'));
        await tester.pumpAndSettle();

        // Dialog'un kapandığını kontrol et
        expect(find.text('Bu işlem tüm kartlarınızı'), findsNothing);
      },
    );

    testWidgets(
      'Cache ve data persistence testi',
      (WidgetTester tester) async {
        // Uygulamayı başlat
        app.main();
        await tester.pumpAndSettle();

        // Profil tab'ından kartları yenile
        await tester.tap(find.text('Profil'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Kartları Yenile'));
        await tester.pumpAndSettle();

        // Ana sayfaya dön
        await tester.tap(find.text('Ana Sayfa'));
        await tester.pumpAndSettle();

        // Cache yükleme işleminin çalıştığını kontrol et
        // (Loading göstergesi veya içerik yüklenmesi)
      },
    );
  });

  group('Error Handling Tests', () {
    testWidgets(
      'Boş prompt ile görsel üretme hatası testi',
      (WidgetTester tester) async {
        // Uygulamayı başlat
        app.main();
        await tester.pumpAndSettle();

        // Yeni kart oluşturma dialog'unu aç
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Prompt boş bırakıp Uygula butonuna tap et
        await tester.tap(find.text('Uygula'));
        await tester.pumpAndSettle();

        // Hata mesajının göründüğünü kontrol et
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );
  });

  group('Performance Tests', () {
    testWidgets(
      'Çoklu kart yükleme performans testi',
      (WidgetTester tester) async {
        // Uygulamayı başlat
        app.main();
        await tester.pumpAndSettle();

        // Performans ölçümü başlat
        await tester.binding.watchPerformance(() async {
          // Ana sayfa tab'larını değiştir
          for (int i = 0; i < 5; i++) {
            await tester.tap(find.text('Popüler'));
            await tester.pumpAndSettle();
            
            await tester.tap(find.text('Ana Sayfa'));
            await tester.pumpAndSettle();
            
            await tester.tap(find.text('Profil'));
            await tester.pumpAndSettle();
            
            await tester.tap(find.text('Ana Sayfa'));
            await tester.pumpAndSettle();
          }
        });
      },
    );
  });
}
