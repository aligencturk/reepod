import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/home_screen.dart';

/// Uygulama route yapılandırması
class AppRoutes {
  AppRoutes._();

  // MARK: - Route Paths
  static const String home = '/';
  
  // Gelecekte eklenecek route'lar için
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String cardDetail = '/card/:id';

  // MARK: - GoRouter Configuration
  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      // Ana sayfa route'u
      GoRoute(
        path: home,
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      
      // Gelecekte eklenecek route'lar
      /*
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (BuildContext context, GoRouterState state) {
          return const SettingsScreen();
        },
      ),
      
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        },
      ),
      
      GoRoute(
        path: cardDetail,
        name: 'cardDetail',
        builder: (BuildContext context, GoRouterState state) {
          final cardId = state.pathParameters['id']!;
          return CardDetailScreen(cardId: cardId);
        },
      ),
      */
    ],
    
    // Hata sayfası
    errorBuilder: (context, state) => _ErrorPage(
      error: state.error.toString(),
    ),
    
    // Route değişikliklerinde çağrılacak
    redirect: (BuildContext context, GoRouterState state) {
      // Burada authentication, onboarding vb. kontroller yapılabilir
      return null; // Redirect yok
    },
  );

  // MARK: - Navigation Methods
  
  /// Ana sayfaya git
  static void goHome(BuildContext context) {
    context.go(home);
  }
  
  /// Ayarlar sayfasına git
  static void goSettings(BuildContext context) {
    context.push(settings);
  }
  
  /// Profil sayfasına git
  static void goProfile(BuildContext context) {
    context.push(profile);
  }
  
  /// Kart detay sayfasına git
  static void goCardDetail(BuildContext context, String cardId) {
    context.push(cardDetail.replaceAll(':id', cardId));
  }
  
  /// Geri git
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }
  
  /// Belirli route'a kadar geri git
  static void goBackUntil(BuildContext context, String routeName) {
    while (context.canPop()) {
      final currentRoute = GoRouterState.of(context).name;
      if (currentRoute == routeName) break;
      context.pop();
    }
  }
  
  /// Tüm stack'i temizleyip belirtilen route'a git
  static void goAndClearStack(BuildContext context, String path) {
    context.go(path);
  }
}

/// Hata sayfası widget'ı
class _ErrorPage extends StatelessWidget {
  final String error;

  const _ErrorPage({
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),
              Color(0xFF1C1C1E),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B30).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Color(0xFFFF3B30),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Error title
                const Text(
                  'Sayfa Bulunamadı',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // Error message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Aradığınız sayfa mevcut değil veya kaldırılmış olabilir.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Home button
                ElevatedButton(
                  onPressed: () => AppRoutes.goHome(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Ana Sayfaya Dön',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Debug info (sadece debug modda göster)
                if (error.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hata Detayı:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Text(
                            error,
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'monospace',
                              color: Colors.white.withOpacity(0.5),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

