import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/countries.dart';
import '../../../home/presentation/widgets/grain_overlay.dart';
import '../../../nostalgia/presentation/providers/chat_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _age = 30;
  String _country = 'ru';
  String _coreMemoryAge = '7-9';
  String _gender = 'male';
  String _countrySearch = '';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _age = prefs.getInt('age') ?? 30;
      _country = prefs.getString('country') ?? 'ru';
      _coreMemoryAge = prefs.getString('core_memory_age') ?? '7-9';
      _gender = prefs.getString('gender') ?? 'male';
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('age', _age);
    await prefs.setString('country', _country);
    await prefs.setString('core_memory_age', _coreMemoryAge);
    await prefs.setString('gender', _gender);

    if (mounted) {
      final strings = ref.read(stringsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.settingsSaved),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _showCountryPicker(AppStrings strings, String localeCode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final filteredCountries = Countries.search(_countrySearch, localeCode);
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) => Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: TextField(
                    onChanged: (value) {
                      setModalState(() => _countrySearch = value);
                    },
                    decoration: InputDecoration(
                      hintText: strings.searchCountry,
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];
                      final isSelected = country.code == _country;
                      return ListTile(
                        title: Text(
                          country.getName(localeCode),
                          style: TextStyle(
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                            : null,
                        onTap: () {
                          setState(() {
                            _country = country.code;
                            _countrySearch = '';
                          });
                          Navigator.pop(context);
                          _saveSettings();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final locale = ref.watch(localeProvider);
    final localeCode = locale.code;

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
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: AppColors.textPrimary,
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        strings.settings,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: AppSpacing.screenPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Language
                              _buildSectionTitle(strings.language),
                              const SizedBox(height: AppSpacing.md),
                              _buildLanguageSelector(),

                              const SizedBox(height: AppSpacing.xxl),

                              // Age
                              _buildSectionTitle(strings.yourAge),
                              const SizedBox(height: AppSpacing.md),
                              _buildAgeSelector(strings),

                              const SizedBox(height: AppSpacing.xxl),

                              // Gender
                              _buildSectionTitle(strings.gender),
                              const SizedBox(height: AppSpacing.md),
                              _buildGenderSelector(strings),

                              const SizedBox(height: AppSpacing.xxl),

                              // Memory age
                              _buildSectionTitle(strings.memoryAge),
                              const SizedBox(height: AppSpacing.md),
                              _buildMemoryAgeSelector(strings),

                              const SizedBox(height: AppSpacing.xxl),

                              // Country
                              _buildSectionTitle(strings.childhoodCountry),
                              const SizedBox(height: AppSpacing.md),
                              _buildCountrySelector(strings, localeCode),

                              const SizedBox(height: AppSpacing.xxl),

                              // Privacy section
                              _buildSectionTitle(localeCode == 'ru' ? 'Конфиденциальность' : 'Privacy'),
                              const SizedBox(height: AppSpacing.md),
                              _buildClearChatButton(localeCode),

                              const SizedBox(height: AppSpacing.xxl),

                              // About section
                              _buildSectionTitle(localeCode == 'ru' ? 'Информация' : 'Information'),
                              const SizedBox(height: AppSpacing.md),
                              _buildAboutLink(localeCode),

                              const SizedBox(height: AppSpacing.xxxl),

                              // App info
                              Center(
                                child: Column(
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (bounds) => const LinearGradient(
                                        colors: [AppColors.primary, AppColors.primaryLight, AppColors.accent],
                                      ).createShader(bounds),
                                      child: Text(
                                        strings.appName,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      '${strings.version} 1.0.0',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    ).animate().fadeIn();
  }

  Widget _buildLanguageSelector() {
    final currentLocale = ref.watch(localeProvider);

    return Row(
      children: AppLocale.values.map((locale) {
        final isSelected = locale == currentLocale;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: locale == AppLocale.en ? AppSpacing.sm : 0,
              left: locale == AppLocale.ru ? AppSpacing.sm : 0,
            ),
            child: InkWell(
              onTap: () => ref.read(localeProvider.notifier).setLocale(locale),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.language_rounded, color: isSelected ? AppColors.primary : AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      locale.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAgeSelector(AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Text(
            '$_age ${strings.yearsOld}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.md),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.surfaceLight,
              thumbColor: AppColors.primary,
            ),
            child: Slider(
              value: _age.toDouble(),
              min: 18,
              max: 70,
              divisions: 52,
              onChanged: (value) => setState(() => _age = value.round()),
              onChangeEnd: (_) => _saveSettings(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector(AppStrings strings) {
    final genders = [
      {'code': 'male', 'name': strings.male},
      {'code': 'female', 'name': strings.female},
    ];

    return Row(
      children: genders.map((gender) {
        final isSelected = gender['code'] == _gender;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: gender['code'] == 'male' ? AppSpacing.sm : 0,
              left: gender['code'] == 'female' ? AppSpacing.sm : 0,
            ),
            child: InkWell(
              onTap: () {
                setState(() => _gender = gender['code']!);
                _saveSettings();
              },
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      gender['code'] == 'male' ? Icons.male_rounded : Icons.female_rounded,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      gender['name']!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMemoryAgeSelector(AppStrings strings) {
    final memoryAges = ['5-7', '7-9', '10-12', '13-15'];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: memoryAges.map((age) {
        final isSelected = age == _coreMemoryAge;
        return InkWell(
          onTap: () {
            setState(() => _coreMemoryAge = age);
            _saveSettings();
          },
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              '$age ${strings.years}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCountrySelector(AppStrings strings, String localeCode) {
    final selectedCountry = Countries.findByCode(_country);
    final countryName = selectedCountry?.getName(localeCode) ?? _country;

    return InkWell(
      onTap: () => _showCountryPicker(strings, localeCode),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.surfaceLight, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                countryName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textTertiary, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildClearChatButton(String localeCode) {
    return InkWell(
      onTap: () => _showClearChatDialog(localeCode),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.surfaceLight, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localeCode == 'ru' ? 'Очистить историю чата' : 'Clear chat history',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    localeCode == 'ru'
                        ? 'Удалить все сообщения из чата'
                        : 'Delete all chat messages',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textTertiary, size: 16),
          ],
        ),
      ),
    );
  }

  void _showClearChatDialog(String localeCode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          localeCode == 'ru' ? 'Очистить чат?' : 'Clear chat?',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          localeCode == 'ru'
              ? 'Все сообщения в чате будут удалены. Это действие нельзя отменить.'
              : 'All chat messages will be deleted. This action cannot be undone.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              localeCode == 'ru' ? 'Отмена' : 'Cancel',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(chatProvider.notifier).reset();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    localeCode == 'ru' ? 'Чат очищен' : 'Chat cleared',
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(
              localeCode == 'ru' ? 'Очистить' : 'Clear',
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutLink(String localeCode) {
    return InkWell(
      onTap: () => context.push('/about'),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.surfaceLight, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                localeCode == 'ru' ? 'О приложении' : 'About the app',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textTertiary, size: 16),
          ],
        ),
      ),
    );
  }
}
