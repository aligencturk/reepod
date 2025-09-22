import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/card_item.dart';
import '../viewmodels/card_view_model.dart';
import '../widgets/flip_card.dart';
import '../widgets/loading_widget.dart' hide ErrorWidget;
import '../services/mock_data_service.dart';
import 'create_page.dart';
import 'profile_page.dart';

/// Ana ekran - AI Image Generator & Social Media
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();

    // Kartları yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CardViewModel>().loadCards();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F), // Netflix koyu arka plan
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F0F), // Netflix koyu siyah
              Color(0xFF1A1A1A), // Biraz daha açık siyah
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Netflix tarzı AppBar
              _buildNetflixAppBar(),

              // Ana içerik - Netflix tarzı scroll view
              Expanded(child: _buildMainContent()),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavBar(),

      // Floating Action Button - Yeni kart oluştur
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Netflix tarzı app bar
  Widget _buildNetflixAppBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Netflix tarzı logo
          Text(
            'REEPOD',
            style: GoogleFonts.bebasNeue(
              textStyle: const TextStyle(
                color: Color(0xFFE50914),
                fontSize: 28,
                letterSpacing: 1.0,
              ),
            ),
          ),

          const Spacer(),

          const Spacer(),

          // Arama ve bildirim ikonları
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 20),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_currentTabIndex) {
      case 0:
        return const _NetflixHomeTab();
      case 1:
        return const CreatePage();
      case 2:
        return const ProfilePage();
      default:
        return const _NetflixHomeTab();
    }
  }

  /// Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F0F),
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F0F0F),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey[400],
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_outlined),
            activeIcon: Icon(Icons.auto_awesome),
            label: 'Oluştur',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Eserlerim',
          ),
        ],
      ),
    );
  }

  /// Netflix tarzı floating action button
  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(colors: [Colors.red, Color(0xFFE50914)]),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {
          _showCreateCardDialog();
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  /// Yeni kart oluşturma dialog'unu gösterir
  void _showCreateCardDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 350,
          height: 500,
          child: const FlipCard(
            startFlipped: true, // Arka yüzle başla
          ),
        ),
      ),
    );
  }
}

/// Netflix tarzı ana sayfa tab'ı
class _NetflixHomeTab extends StatefulWidget {
  const _NetflixHomeTab();

  @override
  State<_NetflixHomeTab> createState() => _NetflixHomeTabState();
}

class _NetflixHomeTabState extends State<_NetflixHomeTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CardViewModel>(
      builder: (context, cardViewModel, child) {
        if (cardViewModel.isLoading && cardViewModel.cards.isEmpty) {
          return const Center(
            child: LoadingWidget.large(message: 'İçerik yükleniyor...'),
          );
        }

        if (cardViewModel.hasError && cardViewModel.cards.isEmpty) {
          return Center(
            child: LoadingWidget.large(
              message: cardViewModel.errorMessage ?? 'Bir hata oluştu',
            ),
          );
        }

        return _buildNetflixHomeContent(cardViewModel);
      },
    );
  }

  Widget _buildNetflixHomeContent(CardViewModel cardViewModel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section - Netflix tarzı büyük kart
          _buildHeroSection(cardViewModel),

          const SizedBox(height: 20),

          // AI Foto Oluşturma Kategorileri
          _buildCategorySection(
            '🔥 Trending AI Art',
            MockDataService.getTrendingCards(),
            isHorizontal: true,
          ),
          _buildCategorySection(
            '🏔️ AI Maceracı',
            MockDataService.getCardsByCategory('AI Maceracı'),
            isHorizontal: true,
          ),
          _buildCategorySection(
            '✨ AI Fantastik',
            MockDataService.getCardsByCategory('AI Fantastik'),
            isHorizontal: true,
          ),
          _buildCategorySection(
            '👤 AI Portre',
            MockDataService.getCardsByCategory('AI Portre'),
            isHorizontal: true,
          ),
          _buildCategorySection(
            '🚀 AI Bilim Kurgu',
            MockDataService.getCardsByCategory('AI Bilim Kurgu'),
            isHorizontal: true,
          ),
          _buildCategorySection(
            '🎨 AI Sanat',
            MockDataService.getCardsByCategory('AI Sanat'),
            isHorizontal: true,
          ),
          _buildCategorySection(
            '🏗️ AI Mimari',
            MockDataService.getCardsByCategory('AI Mimari'),
            isHorizontal: true,
          ),
          _buildCategorySection(
            '🆕 Yeni AI Eserleri',
            cardViewModel.getNewestCards(),
            isHorizontal: true,
          ),

          const SizedBox(height: 100), // FAB için boşluk
        ],
      ),
    );
  }

  Widget _buildHeroSection(CardViewModel cardViewModel) {
    // Mock verilerden featured kartı al
    final heroCard = MockDataService.getFeaturedCard();

    if (heroCard == null) {
      return _buildEmptyHeroSection();
    }
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Arka plan görseli
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                heroCard.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
          ),

          // İçerik
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heroCard.prompt,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'AI Generated • ${heroCard.style}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _showCreateCardDialog(context);
                      },
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('AI ile Oluştur'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download),
                      label: const Text('İndir'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHeroSection() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.red, Color(0xFFE50914)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'AI Foto Oluşturucu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Yapay zeka ile hayal gücünüzü gerçeğe dönüştürün',
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _showCreateCardDialog(context);
              },
              icon: const Icon(Icons.auto_awesome),
              label: const Text('İlk AI Eserini Oluştur'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    String title,
    List<CardItem> cards, {
    required bool isHorizontal,
  }) {
    if (cards.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (isHorizontal)
          _buildHorizontalCardList(cards)
        else
          _buildVerticalCardGrid(cards),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHorizontalCardList(List<CardItem> cards) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            child: _buildNetflixCard(card),
          );
        },
      ),
    );
  }

  Widget _buildVerticalCardGrid(List<CardItem> cards) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return _buildNetflixCard(card);
        },
      ),
    );
  }

  /// Yeni kart oluşturma dialog'unu gösterir
  void _showCreateCardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 350,
          height: 500,
          child: const FlipCard(
            startFlipped: true, // Arka yüzle başla
          ),
        ),
      ),
    );
  }

  /// Kart detay dialog'unu gösterir - Flip animasyonu ile
  void _showCardDetailDialog(BuildContext context, CardItem card) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          width: 360,
          height: 560,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 0,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // FlipCard widget'ı
                Positioned.fill(
                  child: FlipCard(
                    card: card,
                    startFlipped: false, // Ön yüzle başla
                    width: 360,
                    height: 560,
                  ),
                ),

                // Kapatma butonu
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNetflixCard(CardItem card) {
    return GestureDetector(
      onTap: () {
        _showCardDetailDialog(context, card);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Görsel
              Positioned.fill(
                child: Image.network(
                  card.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),

              // AI Badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Başlık
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  card.prompt,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Netflix tarzı popüler tab'ı
// ignore: unused_element
class _NetflixPopularTab extends StatelessWidget {
  const _NetflixPopularTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<CardViewModel>(
      builder: (context, cardViewModel, child) {
        final popularCards = cardViewModel.cards;

        if (popularCards.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.trending_up, size: 80, color: Colors.grey),

                const SizedBox(height: 24),

                const Text(
                  'Henüz popüler içerik yok',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Henüz içerik yok',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return _buildNetflixPopularContent(popularCards);
      },
    );
  }

  Widget _buildNetflixPopularContent(List<CardItem> popularCards) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '⭐ Popüler AI Eserleri',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Popüler kartlar listesi
          _buildPopularCardsList(popularCards),

          const SizedBox(height: 100), // FAB için boşluk
        ],
      ),
    );
  }

  Widget _buildPopularCardsList(List<CardItem> cards) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildPopularCard(card, index + 1),
        );
      },
    );
  }

  Widget _buildPopularCard(CardItem card, int rank) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Sıra numarası
          Container(
            width: 60,
            height: 120,
            decoration: BoxDecoration(
              color: rank <= 3 ? Colors.red : Colors.grey[800],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Kart görseli
          Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  Image.network(
                    card.imageUrl,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.image, color: Colors.grey),
                      );
                    },
                  ),
                  // AI Badge
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Kart bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  card.prompt,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  'Stil: ${card.style}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
