import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/card_view_model.dart';
import '../theme/app_colors.dart';

/// Netflix tarzı profil sayfası
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CardViewModel>(
      builder: (context, cardViewModel, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // Netflix tarzı profil header
              _buildNetflixProfileHeader(cardViewModel),

              const SizedBox(height: 24),

              // İstatistikler
              _buildNetflixStatsSection(cardViewModel),

              const SizedBox(height: 24),

              // Ayarlar menüsü
              _buildNetflixSettingsSection(context, cardViewModel),

              const SizedBox(height: 100), // FAB için boşluk
            ],
          ),
        );
      },
    );
  }

  Widget _buildNetflixProfileHeader(CardViewModel cardViewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 120,
            height: 120,
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
            child: const Icon(Icons.person, size: 60, color: Colors.white),
          ),

          const SizedBox(height: 16),

          // Kullanıcı adı
          const Text(
            'Eserlerim',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Kullanıcı durumu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.red, Color(0xFFE50914)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '🎨 AI Eserlerim',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // İstatistik özeti
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickStat('Toplam Eser', '${cardViewModel.cardCount}'),
              _buildQuickStat(
                'Kategoriler',
                '${_getCategoryCount(cardViewModel)}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  /// Kategori sayısını hesaplar
  int _getCategoryCount(CardViewModel cardViewModel) {
    final categories = cardViewModel.cards.map((card) => card.style).toSet();
    return categories.length;
  }

  /// En çok kullanılan stili döndürür
  String _getMostUsedStyle(CardViewModel cardViewModel) {
    if (cardViewModel.cards.isEmpty) return 'Yok';

    final styleCount = <String, int>{};
    for (final card in cardViewModel.cards) {
      styleCount[card.style] = (styleCount[card.style] ?? 0) + 1;
    }

    if (styleCount.isEmpty) return 'Yok';

    final mostUsed = styleCount.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    return mostUsed.key;
  }

  Widget _buildNetflixStatsSection(CardViewModel cardViewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 Eser İstatistikleri',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildStatRow(
                  'Toplam Eser',
                  '${cardViewModel.cardCount}',
                  Icons.auto_awesome,
                  Colors.blue,
                ),
                const Divider(color: Colors.grey),
                _buildStatRow(
                  'Kategori Sayısı',
                  '${_getCategoryCount(cardViewModel)}',
                  Icons.category,
                  Colors.green,
                ),
                const Divider(color: Colors.grey),
                _buildStatRow(
                  'En Çok Kullanılan Stil',
                  _getMostUsedStyle(cardViewModel),
                  Icons.palette,
                  Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetflixSettingsSection(
    BuildContext context,
    CardViewModel cardViewModel,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚙️ Eser Ayarları',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.auto_awesome,
                  title: 'Eserlerimi Yenile',
                  subtitle: 'Tüm eserlerimi yeniden yükle',
                  onTap: () => cardViewModel.refreshCards(),
                ),
                const Divider(color: Colors.grey, height: 1),
                _buildSettingsItem(
                  icon: Icons.clear_all,
                  title: 'Tüm Eserlerimi Temizle',
                  subtitle: 'Tüm eserlerimi kalıcı olarak sil',
                  onTap: () => _showClearConfirmation(context, cardViewModel),
                  isDestructive: true,
                ),
                const Divider(color: Colors.grey, height: 1),
                _buildSettingsItem(
                  icon: Icons.info_outline,
                  title: 'AI Foto Oluşturucu Hakkında',
                  subtitle: 'Versiyon ve AI bilgileri',
                  onTap: () => _showAboutDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.white,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _showClearConfirmation(
    BuildContext context,
    CardViewModel cardViewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tüm Eserlerimi Temizle'),
        content: const Text(
          'Bu işlem tüm eserlerinizi kalıcı olarak silecek. Devam etmek istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              cardViewModel.clearAllCards();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Temizle'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🤖 AI Foto Oluşturucu'),
        content: const Text(
          'ReePod - AI Image Generator & Social Media\n\n'
          'Yapay zeka teknolojisiyle hayal gücünüzü gerçeğe dönüştürün. '
          'AI ile muhteşem görseller oluşturun ve sosyal medyada paylaşın.\n\n'
          '✨ AI Destekli Foto Oluşturma\n'
          '🎨 Çoklu Sanat Stili\n'
          '📱 Sosyal Medya Entegrasyonu\n\n'
          'Versiyon: 1.0.0',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}
