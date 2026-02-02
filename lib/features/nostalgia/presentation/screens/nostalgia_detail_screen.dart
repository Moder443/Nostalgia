import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../home/presentation/widgets/grain_overlay.dart';
import '../../domain/models/nostalgia_generation.dart';
import '../widgets/nostalgia_content_view.dart';
import '../widgets/loading_shimmer.dart';

class NostalgiaDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const NostalgiaDetailScreen({super.key, required this.id});

  @override
  ConsumerState<NostalgiaDetailScreen> createState() => _NostalgiaDetailScreenState();
}

class _NostalgiaDetailScreenState extends ConsumerState<NostalgiaDetailScreen> {
  NostalgiaGeneration? _generation;
  bool _isLoading = true;
  String? _error;

  String _formatDate(String date) {
    if (date.isEmpty || date.startsWith('0001')) {
      final now = DateTime.now();
      return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    }
    return date;
  }

  @override
  void initState() {
    super.initState();
    _loadNostalgia();
  }

  Future<void> _loadNostalgia() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.getNostalgiaById(widget.id);
      setState(() {
        _generation = NostalgiaGeneration.fromJson(response.data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Не удалось загрузить';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),
          const GrainOverlay(opacity: 0.04),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: () => context.pop(),
                      ),
                      if (_generation != null)
                        Text(
                          _formatDate(_generation!.date),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const LoadingShimmer();
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 64,
                color: AppColors.textTertiary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                _error!,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton(
                onPressed: _loadNostalgia,
                child: const Text('Попробовать снова'),
              ),
            ],
          ),
        ),
      );
    }

    if (_generation == null) {
      return const Center(child: Text('Нет данных'));
    }

    final locale = ref.watch(localeProvider);
    return NostalgiaContentView(
      generation: _generation!,
      language: locale.code,
    ).animate().fadeIn(duration: 800.ms);
  }
}
