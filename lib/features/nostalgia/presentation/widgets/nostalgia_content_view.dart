import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/nostalgia_generation.dart';
import '../providers/chat_provider.dart';

class NostalgiaContentView extends ConsumerStatefulWidget {
  final NostalgiaGeneration generation;
  final String language;

  const NostalgiaContentView({
    super.key,
    required this.generation,
    this.language = 'ru',
  });

  @override
  ConsumerState<NostalgiaContentView> createState() => _NostalgiaContentViewState();
}

class _NostalgiaContentViewState extends ConsumerState<NostalgiaContentView> {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  final _chatController = TextEditingController();
  final _scrollController = ScrollController();

  // Rate limiting: max 10 messages per minute
  final List<DateTime> _messageTimestamps = [];
  static const int _maxMessagesPerMinute = 10;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _initChat();
  }

  void _initChat() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).initialize(
        nostalgiaContext: '${widget.generation.content.title}\n\n${widget.generation.content.body}',
        memoryQuestion: widget.generation.content.memoryQuestion,
        language: widget.language,
      );
    });
  }

  Future<void> _initAudioPlayer() async {
    final audioUrl = widget.generation.media?.ambientAudioUrl;
    if (audioUrl != null && audioUrl.isNotEmpty) {
      _audioPlayer = AudioPlayer();
      try {
        await _audioPlayer!.setUrl(audioUrl);
        await _audioPlayer!.setLoopMode(LoopMode.one);
        await _audioPlayer!.setVolume(0.5);
        await _audioPlayer!.play();
        if (mounted) {
          setState(() => _isPlaying = true);
        }
      } catch (e) {
        debugPrint('Audio init error: $e');
      }
    }
  }

  @override
  void didUpdateWidget(NostalgiaContentView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.generation.media?.ambientAudioUrl !=
        widget.generation.media?.ambientAudioUrl) {
      _audioPlayer?.dispose();
      _initAudioPlayer();
    }
    if (oldWidget.generation.id != widget.generation.id) {
      ref.read(chatProvider.notifier).reset();
      _initChat();
    }
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleAudio() async {
    if (_audioPlayer == null) return;
    if (_isPlaying) {
      await _audioPlayer!.pause();
    } else {
      await _audioPlayer!.play();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  Future<void> _shareMemory() async {
    final isRussian = widget.language == 'ru';
    final content = widget.generation.content;

    // Format the share text
    final shareText = '''
${content.title}

${content.body}

${content.memoryQuestion}

---
${isRussian ? 'Создано в приложении Nostalgia' : 'Created with Nostalgia app'}
${isRussian ? 'Машина времени в твоём кармане' : 'Time machine in your pocket'}
''';

    await Share.share(
      shareText,
      subject: content.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final isRussian = widget.language == 'ru';
    final hasImage = widget.generation.media?.backgroundImageUrl != null &&
        widget.generation.media!.backgroundImageUrl!.isNotEmpty;

    return ListView(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      children: [
        // Full-width image (no parallax)
        if (hasImage) _buildImage(),

        // Content with padding
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                widget.generation.content.title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.primary,
                  height: 1.2,
                ),
              ).animate().fadeIn(duration: 600.ms),

              const SizedBox(height: AppSpacing.xl),

              // Body
              Text(
                widget.generation.content.body,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.8,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 600.ms),

              const SizedBox(height: AppSpacing.xxl),

              // Memory question
              _buildMemoryQuestion(chatState, isRussian),

              // Chat
              if (chatState.showChat) ...[
                const SizedBox(height: AppSpacing.lg),
                _buildChat(chatState, isRussian),
              ],

              const SizedBox(height: AppSpacing.xl),

              // Closing
              if (!chatState.showChat)
                Center(
                  child: Text(
                    widget.generation.content.closing,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: AppSpacing.xl),

              // Share button (always visible at bottom)
              Center(
                child: OutlinedButton.icon(
                  onPressed: _shareMemory,
                  icon: const Icon(Icons.share_rounded, size: 20),
                  label: Text(widget.language == 'ru' ? 'Поделиться' : 'Share'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: widget.generation.media!.backgroundImageUrl!,
          width: double.infinity,
          height: 350,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: 350,
            color: AppColors.surface,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 350,
            color: AppColors.surface,
            child: const Icon(Icons.image, color: AppColors.textTertiary, size: 48),
          ),
        ),
        // Gradient overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.background,
                ],
              ),
            ),
          ),
        ),
        // Action buttons row
        Positioned(
          bottom: 16,
          right: 16,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Share button
              GestureDetector(
                onTap: _shareMemory,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.share_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              // Audio button
              if (_audioPlayer != null) ...[
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _toggleAudio,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      _isPlaying ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemoryQuestion(ChatState chatState, bool isRussian) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.format_quote, color: AppColors.accent, size: 28),
          const SizedBox(height: AppSpacing.sm),
          Text(
            widget.generation.content.memoryQuestion,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          if (chatState.status == ChatStatus.waitingForAnswer) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(chatProvider.notifier).sendAnswer(
                        isRussian ? 'Да, помню!' : 'Yes, I remember!',
                      );
                    },
                    child: Text(isRussian ? 'Да' : 'Yes'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(chatProvider.notifier).sendAnswer(
                        isRussian ? 'Нет, не помню...' : 'No, I don\'t remember...',
                      );
                    },
                    child: Text(isRussian ? 'Нет' : 'No'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildChat(ChatState chatState, bool isRussian) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                isRussian ? 'Разговор' : 'Conversation',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Messages
          for (final msg in chatState.messages)
            if (msg.content.isNotEmpty) _buildMessage(msg.content, msg.role == 'user'),

          // Streaming message
          if (chatState.status == ChatStatus.streaming &&
              chatState.currentStreamingMessage.isNotEmpty)
            _buildMessage(chatState.currentStreamingMessage, false, isStreaming: true),

          // Loading
          if (chatState.status == ChatStatus.streaming &&
              chatState.currentStreamingMessage.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    isRussian ? 'Думаю...' : 'Thinking...',
                    style: TextStyle(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),

          // Error state
          if (chatState.status == ChatStatus.error)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      isRussian ? 'Произошла ошибка. Попробуйте еще раз.' : 'An error occurred. Please try again.',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),

          // Input - show for both ready and error states
          if (chatState.status == ChatStatus.ready || chatState.status == ChatStatus.error) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    maxLength: 500,
                    maxLines: 3,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: isRussian ? 'Напишите...' : 'Type...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      counterStyle: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  onPressed: () => _sendMessage(_chatController.text),
                  icon: Icon(Icons.send, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isUser, {bool isStreaming = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isUser ? AppColors.primary.withValues(alpha: 0.1) : AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (isStreaming)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _isRateLimited() {
    final now = DateTime.now();
    final oneMinuteAgo = now.subtract(const Duration(minutes: 1));

    // Remove timestamps older than 1 minute
    _messageTimestamps.removeWhere((timestamp) => timestamp.isBefore(oneMinuteAgo));

    return _messageTimestamps.length >= _maxMessagesPerMinute;
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Check rate limiting
    if (_isRateLimited()) {
      final isRussian = widget.language == 'ru';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isRussian
              ? 'Слишком много сообщений. Подождите минуту.'
              : 'Too many messages. Please wait a minute.',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // Add timestamp for rate limiting
    _messageTimestamps.add(DateTime.now());

    ref.read(chatProvider.notifier).sendMessage(text);
    _chatController.clear();
  }
}
