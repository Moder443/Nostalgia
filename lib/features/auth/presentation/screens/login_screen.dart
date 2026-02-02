import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../home/presentation/widgets/grain_overlay.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authStateProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        final authState = ref.read(authStateProvider);
        if (authState.hasCompletedOnboarding) {
          context.go('/home');
        } else {
          context.go('/onboarding');
        }
      }
    } catch (e) {
      if (mounted) {
        final strings = ref.read(stringsProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(strings.invalidEmail),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),
          const GrainOverlay(opacity: 0.03),
          SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xxxl),

                  // Logo
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppShadows.glow(AppColors.primary),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        size: 40,
                        color: AppColors.background,
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.8, 0.8)),

                  const SizedBox(height: AppSpacing.xl),

                  // Title
                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight, AppColors.accent],
                      ).createShader(bounds),
                      child: Text(
                        strings.appName,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ).animate(delay: 200.ms).fadeIn(),

                  const SizedBox(height: AppSpacing.xxxl),

                  // Welcome text
                  Text(
                    strings.welcomeBack,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2, end: 0),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    strings.loginToReturn,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ).animate(delay: 500.ms).fadeIn(),

                  const SizedBox(height: AppSpacing.xxl),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: strings.email,
                            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textTertiary),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return strings.enterEmail;
                            }
                            if (!value.contains('@')) {
                              return strings.invalidEmail;
                            }
                            return null;
                          },
                        ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.1, end: 0),

                        const SizedBox(height: AppSpacing.md),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _login(),
                          decoration: InputDecoration(
                            hintText: strings.password,
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textTertiary),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: AppColors.textTertiary,
                              ),
                              onPressed: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return strings.enterPassword;
                            }
                            return null;
                          },
                        ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.1, end: 0),

                        const SizedBox(height: AppSpacing.xl),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.background,
                                    ),
                                  )
                                : Text(strings.login),
                          ),
                        ).animate(delay: 800.ms).fadeIn(),

                        const SizedBox(height: AppSpacing.xl),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              strings.noAccount,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => context.go('/auth/register'),
                              child: Text(
                                strings.register,
                                style: const TextStyle(color: AppColors.primary),
                              ),
                            ),
                          ],
                        ).animate(delay: 900.ms).fadeIn(),
                      ],
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
}
