import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../home/presentation/widgets/grain_overlay.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isRussian = locale.code == 'ru';

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),
          const GrainOverlay(opacity: 0.02),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: AppColors.textPrimary,
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        isRussian ? 'О приложении' : 'About',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: AppSpacing.xl),

                        // App logo/icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary,
                                AppColors.accent,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // App name
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primaryLight,
                              AppColors.accent,
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'Nostalgia',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xs),

                        Text(
                          isRussian
                              ? 'Машина времени в твоём кармане'
                              : 'Time machine in your pocket',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.sm),

                        Text(
                          isRussian ? 'Версия 1.0.0' : 'Version 1.0.0',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xxl),

                        // AI Disclaimer - Important!
                        _buildDisclaimerCard(
                          context,
                          icon: Icons.auto_awesome,
                          iconColor: AppColors.accent,
                          title: isRussian ? 'Контент от ИИ' : 'AI-Generated Content',
                          message: isRussian
                              ? 'Все воспоминания и ответы в чате генерируются искусственным интеллектом. Контент создаётся на основе общих культурных воспоминаний и может не соответствовать вашему личному опыту.'
                              : 'All memories and chat responses are generated by artificial intelligence. Content is created based on general cultural memories and may not match your personal experience.',
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Emergency Disclaimer
                        _buildDisclaimerCard(
                          context,
                          icon: Icons.warning_amber_rounded,
                          iconColor: AppColors.error,
                          title: isRussian ? 'Важное предупреждение' : 'Important Notice',
                          message: isRussian
                              ? 'Это приложение не предназначено для оказания экстренной психологической помощи. Если вам нужна срочная помощь, пожалуйста, обратитесь к специалисту или позвоните на горячую линию.'
                              : 'This app is not intended for emergency psychological support. If you need urgent help, please contact a professional or call a helpline.',
                        ),

                        const SizedBox(height: AppSpacing.xxl),

                        // Links section
                        _buildLinkItem(
                          context,
                          icon: Icons.privacy_tip_outlined,
                          title: isRussian ? 'Политика конфиденциальности' : 'Privacy Policy',
                          onTap: () => _launchUrl('https://moder443.github.io/Nostalgia/privacy.html'),
                        ),

                        _buildLinkItem(
                          context,
                          icon: Icons.description_outlined,
                          title: isRussian ? 'Условия использования' : 'Terms of Service',
                          onTap: () => _launchUrl('https://moder443.github.io/Nostalgia/terms.html'),
                        ),

                        _buildLinkItem(
                          context,
                          icon: Icons.mail_outline_rounded,
                          title: isRussian ? 'Связаться с нами' : 'Contact Us',
                          onTap: () => _launchUrl('mailto:white.scan@proton.me'),
                        ),

                        const SizedBox(height: AppSpacing.xxl),

                        // Copyright
                        Text(
                          '© 2024 RetroVibe',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xs),

                        Text(
                          isRussian
                              ? 'Сделано с любовью к воспоминаниям'
                              : 'Made with love for memories',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
