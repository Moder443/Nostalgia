import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../widgets/grain_overlay.dart';
import '../widgets/breathing_circle.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),

          // Grain overlay for nostalgic effect
          const GrainOverlay(opacity: 0.03),

          // Main content
          SafeArea(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primaryLight,
                            AppColors.accent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          'Nostalgia',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_rounded, color: AppColors.textTertiary),
                        onPressed: () => context.push('/settings'),
                      ),
                    ],
                  ).animate().fadeIn(duration: 500.ms),

                  const SizedBox(height: AppSpacing.xl),

                  // Greeting
                  Text(
                    strings.welcome,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ).animate(delay: 200.ms).fadeIn(),

                  const SizedBox(height: AppSpacing.xxxl),

                  // Main action - breathing circle
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: () => context.push('/nostalgia/daily'),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const BreathingCircle()
                                .animate(delay: 400.ms)
                                .fadeIn(duration: 800.ms)
                                .scale(begin: const Offset(0.9, 0.9)),

                            const SizedBox(height: AppSpacing.xl),

                            Text(
                              strings.goBackFor5Min,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ).animate(delay: 600.ms).fadeIn(),

                            const SizedBox(height: AppSpacing.sm),

                            Text(
                              strings.tapToImmerse,
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ).animate(delay: 800.ms).fadeIn(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () => context.push('/nostalgia/history'),
                        icon: const Icon(Icons.history_rounded, size: 20),
                        label: Text(strings.history),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ).animate(delay: 1000.ms).fadeIn(),

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
