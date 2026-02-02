import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../home/presentation/widgets/grain_overlay.dart';

// Provider for consent state
final consentAcceptedProvider = StateProvider<bool?>((ref) => null);

class ConsentScreen extends ConsumerStatefulWidget {
  const ConsentScreen({super.key});

  @override
  ConsumerState<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends ConsumerState<ConsentScreen> {
  bool _termsAccepted = false;
  bool _privacyAccepted = false;
  bool _aiDisclaimerAccepted = false;
  bool _isLoading = false;
  bool _checkingConsent = true;

  bool get _canContinue => _termsAccepted && _privacyAccepted && _aiDisclaimerAccepted;

  @override
  void initState() {
    super.initState();
    _checkExistingConsent();
  }

  Future<void> _checkExistingConsent() async {
    final hasConsent = await checkConsentAccepted();
    if (hasConsent && mounted) {
      context.go('/splash');
    } else {
      setState(() => _checkingConsent = false);
    }
  }

  Future<void> _acceptAndContinue() async {
    if (!_canContinue) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('consent_accepted', true);
      await prefs.setString('consent_date', DateTime.now().toIso8601String());

      ref.read(consentAcceptedProvider.notifier).state = true;

      if (mounted) {
        context.go('/splash');
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final isRussian = locale.code == 'ru';

    // Show loading while checking consent
    if (_checkingConsent) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),
          const GrainOverlay(opacity: 0.02),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.xl),

                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.accent],
                      ),
                      borderRadius: BorderRadius.circular(20),
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
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Title
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight, AppColors.accent],
                    ).createShader(bounds),
                    child: Text(
                      'Nostalgia',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Welcome text
                  Text(
                    isRussian
                        ? 'Добро пожаловать!'
                        : 'Welcome!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    isRussian
                        ? 'Прежде чем начать, пожалуйста, ознакомьтесь и примите наши условия'
                        : 'Before we begin, please review and accept our terms',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Checkboxes
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Terms of Service
                          _buildConsentItem(
                            context,
                            isRussian: isRussian,
                            value: _termsAccepted,
                            onChanged: (v) => setState(() => _termsAccepted = v ?? false),
                            title: isRussian ? 'Условия использования' : 'Terms of Service',
                            description: isRussian
                                ? 'Я прочитал(а) и принимаю Условия использования'
                                : 'I have read and accept the Terms of Service',
                            linkText: isRussian ? 'Читать условия' : 'Read Terms',
                            url: 'https://moder443.github.io/Nostalgia/terms.html',
                          ),

                          const SizedBox(height: AppSpacing.md),

                          // Privacy Policy
                          _buildConsentItem(
                            context,
                            isRussian: isRussian,
                            value: _privacyAccepted,
                            onChanged: (v) => setState(() => _privacyAccepted = v ?? false),
                            title: isRussian ? 'Политика конфиденциальности' : 'Privacy Policy',
                            description: isRussian
                                ? 'Я прочитал(а) и принимаю Политику конфиденциальности'
                                : 'I have read and accept the Privacy Policy',
                            linkText: isRussian ? 'Читать политику' : 'Read Policy',
                            url: 'https://moder443.github.io/Nostalgia/privacy.html',
                          ),

                          const SizedBox(height: AppSpacing.md),

                          // AI Disclaimer
                          _buildConsentItem(
                            context,
                            isRussian: isRussian,
                            value: _aiDisclaimerAccepted,
                            onChanged: (v) => setState(() => _aiDisclaimerAccepted = v ?? false),
                            title: isRussian ? 'Контент от ИИ' : 'AI-Generated Content',
                            description: isRussian
                                ? 'Я понимаю, что весь контент генерируется ИИ и не является реальными воспоминаниями. Приложение не предназначено для экстренной психологической помощи.'
                                : 'I understand that all content is AI-generated and not real memories. This app is not intended for emergency psychological support.',
                            icon: Icons.auto_awesome,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canContinue && !_isLoading ? _acceptAndContinue : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        disabledBackgroundColor: AppColors.surface,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isRussian ? 'Продолжить' : 'Continue',
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Decline option
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          title: Text(
                            isRussian ? 'Вы уверены?' : 'Are you sure?',
                          ),
                          content: Text(
                            isRussian
                                ? 'Без принятия условий вы не сможете использовать приложение.'
                                : 'You cannot use the app without accepting the terms.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(isRussian ? 'Назад' : 'Go Back'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      isRussian ? 'Не принимаю' : 'Decline',
                      style: TextStyle(color: AppColors.textTertiary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentItem(
    BuildContext context, {
    required bool isRussian,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String title,
    required String description,
    String? linkText,
    String? url,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: value ? AppColors.primary.withValues(alpha: 0.5) : AppColors.surfaceLight,
          width: value ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.accent, size: 20),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (url != null)
                TextButton(
                  onPressed: () => _launchUrl(url),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    linkText ?? (isRussian ? 'Читать' : 'Read'),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: value,
                  onChanged: onChanged,
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(!value),
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Helper to check consent status
Future<bool> checkConsentAccepted() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('consent_accepted') ?? false;
}
