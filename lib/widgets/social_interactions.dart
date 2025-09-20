import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/card_item.dart';
import '../models/comment.dart';
import '../viewmodels/card_view_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import '../theme/app_text_styles.dart';
import 'loading_widget.dart';

/// Sosyal etkileşim butonları (beğen, yorum, paylaş)
class SocialInteractionBar extends StatelessWidget {
  /// İlgili kart
  final CardItem card;
  
  /// Beğeni değiştiğinde çağrılacak callback
  final VoidCallback? onLikeChanged;
  
  /// Yorum eklendiğinde çağrılacak callback
  final VoidCallback? onCommentAdded;

  const SocialInteractionBar({
    super.key,
    required this.card,
    this.onLikeChanged,
    this.onCommentAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Beğen butonu
          _LikeButton(
            card: card,
            onPressed: onLikeChanged,
          ),
          
          // Yorum butonu
          _CommentButton(
            card: card,
            onPressed: () => _showCommentsBottomSheet(context),
          ),
          
          // Paylaş butonu
          _ShareButton(
            card: card,
            onPressed: () => _shareCard(context),
          ),
        ],
      ),
    );
  }

  /// Yorumlar bottom sheet'ini gösterir
  void _showCommentsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsBottomSheet(
        card: card,
        onCommentAdded: onCommentAdded,
      ),
    );
  }

  /// Kartı paylaşır
  void _shareCard(BuildContext context) {
    // Paylaşım işlemi burada implement edilecek
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Paylaşım özelliği yakında eklenecek'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

/// Beğen butonu widget'ı
class _LikeButton extends StatefulWidget {
  final CardItem card;
  final VoidCallback? onPressed;

  const _LikeButton({
    required this.card,
    this.onPressed,
  });

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.animationDurationFast,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLike() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // Animasyon çal
    await _controller.forward();
    await _controller.reverse();

    try {
      final cardViewModel = context.read<CardViewModel>();
      await cardViewModel.toggleLike(widget.card.id);
      widget.onPressed?.call();
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            onTap: _handleLike,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.card.isLiked 
                        ? Icons.favorite 
                        : Icons.favorite_border,
                    color: widget.card.isLiked 
                        ? AppColors.like 
                        : AppColors.textSecondary,
                    size: AppConstants.iconSizeMedium,
                  ),
                  
                  const SizedBox(width: AppConstants.marginSmall),
                  
                  Text(
                    '${widget.card.likes}',
                    style: AppTextStyles.stats.copyWith(
                      color: widget.card.isLiked 
                          ? AppColors.like 
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Yorum butonu widget'ı
class _CommentButton extends StatelessWidget {
  final CardItem card;
  final VoidCallback? onPressed;

  const _CommentButton({
    required this.card,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.comment_outlined,
              color: AppColors.comment,
              size: AppConstants.iconSizeMedium,
            ),
            
            const SizedBox(width: AppConstants.marginSmall),
            
            Text(
              '${card.comments.length}',
              style: AppTextStyles.stats.copyWith(
                color: AppColors.comment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paylaş butonu widget'ı
class _ShareButton extends StatelessWidget {
  final CardItem card;
  final VoidCallback? onPressed;

  const _ShareButton({
    required this.card,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.share_outlined,
              color: AppColors.share,
              size: AppConstants.iconSizeMedium,
            ),
            
            SizedBox(width: AppConstants.marginSmall),
            
            Text(
              'Paylaş',
              style: TextStyle(
                color: AppColors.share,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Yorumlar bottom sheet widget'ı
class CommentsBottomSheet extends StatefulWidget {
  final CardItem card;
  final VoidCallback? onCommentAdded;

  const CommentsBottomSheet({
    super.key,
    required this.card,
    this.onCommentAdded,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAddingComment = false;

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isAddingComment = true;
    });

    try {
      final cardViewModel = context.read<CardViewModel>();
      
      final success = await cardViewModel.addComment(
        cardId: widget.card.id,
        content: _commentController.text.trim(),
        authorName: 'Kullanıcı', // Gerçek uygulamada kullanıcı adını al
      );

      if (success) {
        _commentController.clear();
        widget.onCommentAdded?.call();
        
        // Yeni yoruma scroll et
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: AppConstants.animationDurationMedium,
              curve: Curves.easeOut,
            );
          }
        });
      } else {
        _showError(cardViewModel.errorMessage ?? 'Yorum eklenemedi');
      }
    } finally {
      setState(() {
        _isAddingComment = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return GlassmorphicContainer(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.7 + keyboardHeight,
      borderRadius: AppConstants.bottomSheetBorderRadius,
      blur: AppConstants.glassBlur,
      alignment: Alignment.bottomCenter,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surface,
          AppColors.surfaceVariant,
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.cardBorder,
          AppColors.cardBorder.withOpacity(0.5),
        ],
      ),
      child: Column(
        children: [
          // Başlık ve handle
          Container(
            padding: AppConstants.paddingAll,
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                const SizedBox(height: AppConstants.marginMedium),
                
                Text(
                  'Yorumlar (${widget.card.comments.length})',
                  style: AppTextStyles.headline6,
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Yorumlar listesi
          Expanded(
            child: Consumer<CardViewModel>(
              builder: (context, cardViewModel, child) {
                final updatedCard = cardViewModel.getCard(widget.card.id);
                final comments = updatedCard?.comments ?? widget.card.comments;
                
                if (comments.isEmpty) {
                  return const Center(
                    child: Text(
                      'Henüz yorum yapılmamış.\nİlk yorumu sen yap!',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                
                return ListView.builder(
                  controller: _scrollController,
                  padding: AppConstants.paddingAll,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return _CommentItem(comment: comment);
                  },
                );
              },
            ),
          ),
          
          const Divider(height: 1),
          
          // Yorum ekleme alanı
          Container(
            padding: EdgeInsets.only(
              left: AppConstants.paddingMedium,
              right: AppConstants.paddingMedium,
              top: AppConstants.paddingMedium,
              bottom: AppConstants.paddingMedium + keyboardHeight,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Yorumunuzu yazın...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _addComment(),
                  ),
                ),
                
                const SizedBox(width: AppConstants.marginMedium),
                
                FloatingActionButton(
                  mini: true,
                  onPressed: _isAddingComment ? null : _addComment,
                  child: _isAddingComment
                      ? const LoadingWidget.small()
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tek bir yorum item widget'ı
class _CommentItem extends StatelessWidget {
  final Comment comment;

  const _CommentItem({
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.marginMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.getRandomAccentColor(),
            child: Text(
              comment.authorName.isNotEmpty 
                  ? comment.authorName[0].toUpperCase()
                  : '?',
              style: AppTextStyles.button.copyWith(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
          ),
          
          const SizedBox(width: AppConstants.marginMedium),
          
          // Yorum içeriği
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Yazar adı ve zaman
                Row(
                  children: [
                    Text(
                      comment.authorName,
                      style: AppTextStyles.cardSubtitle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(width: AppConstants.marginSmall),
                    
                    Text(
                      _formatTime(comment.createdAt),
                      style: AppTextStyles.timestamp,
                    ),
                  ],
                ),
                
                const SizedBox(height: AppConstants.marginSmall),
                
                // Yorum metni
                Text(
                  comment.content,
                  style: AppTextStyles.bodyText2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}g';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}s';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}d';
    } else {
      return 'şimdi';
    }
  }
}
