import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/countries.dart';
import '../../../home/presentation/widgets/grain_overlay.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  int _age = 30;
  String _country = 'ru';
  String _coreMemoryAge = '7-9';
  String _gender = 'male';
  String _countrySearch = '';

  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    setState(() => _isLoading = true);

    try {
      // Save settings locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('age', _age);
      await prefs.setString('country', _country);
      await prefs.setString('core_memory_age', _coreMemoryAge);
      await prefs.setString('gender', _gender);
      await prefs.setBool('onboarding_completed', true);

      if (mounted) {
        context.go('/home');
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
    final locale = ref.watch(localeProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: AppColors.backgroundGradient)),
          const GrainOverlay(opacity: 0.03),
          SafeArea(
            child: Column(
              children: [
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: List.generate(4, (index) {
                      return Expanded(
                        child: Container(
                          height: 3,
                          margin: EdgeInsets.only(right: index < 3 ? AppSpacing.sm : 0),
                          decoration: BoxDecoration(
                            color: index <= _currentPage ? AppColors.primary : AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Pages
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) => setState(() => _currentPage = page),
                    children: [
                      _buildAgePage(strings),
                      _buildGenderPage(strings),
                      _buildCountryPage(strings, locale.code),
                      _buildMemoryAgePage(strings),
                    ],
                  ),
                ),

                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      if (_currentPage > 0)
                        Expanded(child: OutlinedButton(onPressed: _previousPage, child: Text(strings.back)))
                      else
                        const Spacer(),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : (_currentPage == 3 ? _completeOnboarding : _nextPage),
                          child: _isLoading
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background))
                              : Text(_currentPage == 3 ? strings.start : strings.next),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgePage(AppStrings strings) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Text(strings.howOldAreYou, style: Theme.of(context).textTheme.displaySmall).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: AppSpacing.md),
          Text(strings.helpFindChildhood, style: Theme.of(context).textTheme.bodyMedium).animate(delay: 200.ms).fadeIn(),
          const Spacer(),
          Center(
            child: Column(
              children: [
                Text('$_age', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.primary, fontSize: 72)),
                const SizedBox(height: AppSpacing.xl),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(activeTrackColor: AppColors.primary, inactiveTrackColor: AppColors.surfaceLight, thumbColor: AppColors.primary),
                  child: Slider(value: _age.toDouble(), min: 18, max: 70, divisions: 52, onChanged: (value) => setState(() => _age = value.round())),
                ),
              ],
            ),
          ).animate(delay: 400.ms).fadeIn(),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildGenderPage(AppStrings strings) {
    final genders = [{'code': 'male', 'name': strings.male, 'icon': '👦'}, {'code': 'female', 'name': strings.female, 'icon': '👧'}];

    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Text(strings.boyOrGirl, style: Theme.of(context).textTheme.displaySmall).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: AppSpacing.md),
          Text(strings.helpCreateMemories, style: Theme.of(context).textTheme.bodyMedium).animate(delay: 200.ms).fadeIn(),
          const SizedBox(height: AppSpacing.xxl),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: genders.map((gender) {
                  final isSelected = gender['code'] == _gender;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      child: InkWell(
                        onTap: () => setState(() => _gender = gender['code']!),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl, horizontal: AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            border: Border.all(color: isSelected ? AppColors.primary : AppColors.surfaceLight, width: isSelected ? 2 : 1),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(gender['icon']!, style: const TextStyle(fontSize: 48)),
                              const SizedBox(height: AppSpacing.md),
                              Text(gender['name']!, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: isSelected ? AppColors.primary : AppColors.textPrimary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                              if (isSelected) ...[const SizedBox(height: AppSpacing.sm), const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 24)],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ).animate(delay: 400.ms).fadeIn(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryPage(AppStrings strings, String localeCode) {
    final filteredCountries = Countries.search(_countrySearch, localeCode);

    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Text(strings.whereDidYouGrowUp, style: Theme.of(context).textTheme.displaySmall).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: AppSpacing.md),
          Text(strings.selectCountry, style: Theme.of(context).textTheme.bodyMedium).animate(delay: 200.ms).fadeIn(),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            onChanged: (value) => setState(() => _countrySearch = value),
            decoration: InputDecoration(
              hintText: strings.searchCountry,
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.lg), borderSide: BorderSide.none),
            ),
          ).animate(delay: 300.ms).fadeIn(),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCountries.length,
              itemBuilder: (context, index) {
                final country = filteredCountries[index];
                final isSelected = country.code == _country;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: InkWell(
                    onTap: () => setState(() => _country = country.code),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.surfaceLight, width: isSelected ? 2 : 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(country.getName(localeCode), style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: isSelected ? AppColors.primary : AppColors.textPrimary))),
                          if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryAgePage(AppStrings strings) {
    final memoryAges = [{'code': '5-7', 'name': '5-7 ${strings.years}'}, {'code': '7-9', 'name': '7-9 ${strings.years}'}, {'code': '10-12', 'name': '10-12 ${strings.years}'}, {'code': '13-15', 'name': '13-15 ${strings.years}'}];

    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Text(strings.whatAgeToRemember, style: Theme.of(context).textTheme.displaySmall).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: AppSpacing.md),
          Text(strings.selectPeriod, style: Theme.of(context).textTheme.bodyMedium).animate(delay: 200.ms).fadeIn(),
          const SizedBox(height: AppSpacing.xxl),
          Expanded(
            child: ListView.builder(
              itemCount: memoryAges.length,
              itemBuilder: (context, index) {
                final memoryAge = memoryAges[index];
                final isSelected = memoryAge['code'] == _coreMemoryAge;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: InkWell(
                    onTap: () => setState(() => _coreMemoryAge = memoryAge['code']!),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.surfaceLight, width: isSelected ? 2 : 1),
                      ),
                      child: Row(
                        children: [
                          Text(memoryAge['name']!, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                          const Spacer(),
                          if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                ).animate(delay: Duration(milliseconds: index * 100)).fadeIn().slideX(begin: 0.1, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}
