import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../home/presentation/widgets/grain_overlay.dart';
import '../providers/nostalgia_provider.dart';
import '../widgets/nostalgia_content_view.dart';
import '../widgets/time_travel_loader.dart';

class DailyNostalgiaScreen extends ConsumerStatefulWidget {
  const DailyNostalgiaScreen({super.key});

  @override
  ConsumerState<DailyNostalgiaScreen> createState() => _DailyNostalgiaScreenState();
}

class _DailyNostalgiaScreenState extends ConsumerState<DailyNostalgiaScreen> {
  String _formatDate(String date) {
    // Handle invalid/empty dates from API
    if (date.isEmpty || date.startsWith('0001')) {
      final now = DateTime.now();
      return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    }
    return date;
  }

  @override
  void initState() {
    super.initState();
    // Fetch daily nostalgia on screen load with current language
    Future.microtask(() {
      final locale = ref.read(localeProvider);
      ref.read(dailyNostalgiaProvider.notifier).fetchDaily(language: locale.code);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dailyNostalgiaProvider);
    final strings = ref.watch(stringsProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),

          // Grain overlay
          const GrainOverlay(opacity: 0.04),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
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
                          Icons.close_rounded,
                          color: AppColors.textTertiary,
                        ),
                        onPressed: () => context.pop(),
                      ),
                      if (state.generation != null)
                        Text(
                          _formatDate(state.generation!.date),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      const SizedBox(width: 48), // Balance
                    ],
                  ),
                ),

                // Main content area
                Expanded(
                  child: _buildContent(state, strings, locale.code),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(DailyNostalgiaState state, AppStrings strings, String language) {
    if (state.isLoading) {
      return const TimeTravelLoader();
    }

    if (state.error != null) {
      return _buildErrorState(strings, language);
    }

    if (state.generation == null) {
      return Center(
        child: Text(strings.errorLoading),
      );
    }

    return NostalgiaContentView(
      generation: state.generation!,
      language: language,
    ).animate().fadeIn(duration: 800.ms);
  }

  Widget _buildErrorState(AppStrings strings, String language) {
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
              strings.errorLoading,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              language == 'ru' ? 'Попробуйте позже' : 'Please try again later',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton(
              onPressed: () {
                ref.read(dailyNostalgiaProvider.notifier).fetchDaily(language: language);
              },
              child: Text(strings.regenerate),
            ),
          ],
        ),
      ),
    );
  }
}
