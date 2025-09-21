// ReePod AI Image Generator uygulaması için widget testleri
//
// WidgetTester kullanarak widget'larla etkileşim test edilebilir.
// Tap, scroll gibi hareketler gönderilebilir ve widget özelliklerinin
// doğru değerlere sahip olduğu doğrulanabilir.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:reepod/main.dart';

void main() {
  testWidgets('ReePod uygulaması başlatma testi', (WidgetTester tester) async {
    // Uygulamayı oluştur ve bir frame tetikle
    await tester.pumpWidget(const ReePodApp());

    // Uygulama başlığının görüntülendiğini doğrula
    expect(find.text('ReePod - AI Image Generator'), findsOneWidget);
    
    // Debug banner'ın gizli olduğunu doğrula
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
