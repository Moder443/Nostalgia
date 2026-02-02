import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../home/presentation/widgets/grain_overlay.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authStateProvider.notifier).register(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        context.go('/onboarding');
      }
    } catch (e) {
      if (mounted) {
        final strings = ref.read(stringsProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(strings.errorSaving),
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
                  const SizedBox(height: AppSpacing.xl),

                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AppColors.textPrimary,
                    onPressed: () => context.go('/auth/login'),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Title
                  Text(
                    strings.createAccount,
                    style: Theme.of(context).textTheme.displaySmall,
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    strings.registerToStart,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ).animate(delay: 200.ms).fadeIn(),

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
                        ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1, end: 0),

                        const SizedBox(height: AppSpacing.md),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
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
                            if (value.length < 6) {
                              return strings.passwordTooShort;
                            }
                            return null;
                          },
                        ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1, end: 0),

                        const SizedBox(height: AppSpacing.md),

                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _register(),
                          decoration: InputDecoration(
                            hintText: strings.confirmPassword,
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textTertiary),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: AppColors.textTertiary,
                              ),
                              onPressed: () {
                                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return strings.confirmPassword;
                            }
                            if (value != _passwordController.text) {
                              return strings.passwordsDoNotMatch;
                            }
                            return null;
                          },
                        ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.1, end: 0),

                        const SizedBox(height: AppSpacing.xl),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _register,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.background,
                                    ),
                                  )
                                : Text(strings.createAccount),
                          ),
                        ).animate(delay: 600.ms).fadeIn(),

                        const SizedBox(height: AppSpacing.xl),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              strings.haveAccount,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => context.go('/auth/login'),
                              child: Text(
                                strings.login,
                                style: const TextStyle(color: AppColors.primary),
                              ),
                            ),
                          ],
                        ).animate(delay: 700.ms).fadeIn(),
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
