import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Supported locales
enum AppLocale {
  en('en', 'English'),
  ru('ru', 'Русский');

  final String code;
  final String name;
  const AppLocale(this.code, this.name);

  static AppLocale fromCode(String code) {
    return AppLocale.values.firstWhere(
      (l) => l.code == code,
      orElse: () => AppLocale.en,
    );
  }
}

// Localization strings
class AppStrings {
  final String locale;

  AppStrings(this.locale);

  // Common
  String get appName => _t('appName', 'Nostalgia', 'Nostalgia');
  String get appTagline => _t('appTagline', 'go back for 5 minutes', 'вернись на 5 минут');
  String get appSlogan => _t('appSlogan', 'Time machine in your pocket', 'Машина времени в твоём кармане');
  String get version => _t('version', 'Version', 'Версия');

  // Navigation
  String get back => _t('back', 'Back', 'Назад');
  String get next => _t('next', 'Next', 'Далее');
  String get start => _t('start', 'Start', 'Начать');
  String get save => _t('save', 'Save', 'Сохранить');
  String get history => _t('history', 'History', 'История');
  String get settings => _t('settings', 'Settings', 'Настройки');

  // Home
  String get welcome => _t('welcome', 'Welcome', 'Добро пожаловать');
  String get goBackFor5Min => _t('goBackFor5Min', 'Go back for 5 minutes', 'Вернуться на 5 минут');
  String get tapToImmerse => _t('tapToImmerse', 'Tap to immerse in memories', 'Нажми, чтобы погрузиться в воспоминания');

  // Onboarding
  String get howOldAreYou => _t('howOldAreYou', 'How old are you?', 'Сколько тебе лет?');
  String get helpFindChildhood => _t('helpFindChildhood', 'This will help us find your childhood', 'Это поможет нам найти твоё детство');
  String get boyOrGirl => _t('boyOrGirl', 'Are you a boy or a girl?', 'Ты мальчик или девочка?');
  String get helpCreateMemories => _t('helpCreateMemories', 'This will help create more personal memories', 'Это поможет создать более личные воспоминания');
  String get whereDidYouGrowUp => _t('whereDidYouGrowUp', 'Where did you grow up?', 'Где ты вырос?');
  String get selectCountry => _t('selectCountry', 'Select your childhood country', 'Выбери страну твоего детства');
  String get whatAgeToRemember => _t('whatAgeToRemember', 'What age to remember?', 'Какой возраст вспомнить?');
  String get selectPeriod => _t('selectPeriod', 'Select the period you want to relive', 'Выбери период, который хочешь пережить снова');

  // Gender
  String get male => _t('male', 'Male', 'Мужской');
  String get female => _t('female', 'Female', 'Женский');

  // Age ranges
  String get years => _t('years', 'years', 'лет');
  String get yearsOld => _t('yearsOld', 'years old', 'лет');

  // Settings
  String get yourAge => _t('yourAge', 'Your age', 'Твой возраст');
  String get gender => _t('gender', 'Gender', 'Пол');
  String get memoryAge => _t('memoryAge', 'Memory age', 'Возраст воспоминаний');
  String get whatPeriodToRemember => _t('whatPeriodToRemember', 'What childhood period to remember?', 'Какой период детства вспоминать?');
  String get childhoodCountry => _t('childhoodCountry', 'Childhood country', 'Страна детства');
  String get language => _t('language', 'Language', 'Язык');

  // Errors
  String get errorSaving => _t('errorSaving', 'Error saving. Try again.', 'Ошибка сохранения. Попробуйте снова.');
  String get errorLoading => _t('errorLoading', 'Error loading profile', 'Ошибка загрузки профиля');
  String get settingsSaved => _t('settingsSaved', 'Settings saved', 'Настройки сохранены');

  // Loading stages
  String get launchingTimeMachine => _t('launchingTimeMachine', 'Launching time machine...', 'Запускаю машину времени...');
  String get goingToPast => _t('goingToPast', 'Going to the past...', 'Отправляюсь в прошлое...');
  String get searchingMemories => _t('searchingMemories', 'Searching for your memories...', 'Ищу твои воспоминания...');
  String get foundSomethingWarm => _t('foundSomethingWarm', 'Found something warm...', 'Нашёл что-то тёплое...');
  String get pickingMusic => _t('pickingMusic', 'Picking music...', 'Подбираю музыку...');
  String get creatingAtmosphere => _t('creatingAtmosphere', 'Creating atmosphere...', 'Создаю атмосферу...');

  // History
  String get noMemoriesYet => _t('noMemoriesYet', 'No memories yet', 'Пока нет воспоминаний');
  String get startFirstJourney => _t('startFirstJourney', 'Start your first journey into the past', 'Начните своё первое путешествие в прошлое');
  String get createMemory => _t('createMemory', 'Create memory', 'Создать воспоминание');

  // Daily nostalgia
  String get regenerate => _t('regenerate', 'Generate new', 'Сгенерировать новое');
  String get listenMusic => _t('listenMusic', 'Listen to music', 'Слушать музыку');
  String get stopMusic => _t('stopMusic', 'Stop music', 'Остановить музыку');

  // Search
  String get searchCountry => _t('searchCountry', 'Search country...', 'Поиск страны...');

  // Auth screens
  String get welcomeBack => _t('welcomeBack', 'Welcome back', 'С возвращением');
  String get loginToReturn => _t('loginToReturn', 'Log in to return to childhood', 'Войди, чтобы вернуться в детство');
  String get email => _t('email', 'Email', 'Почта');
  String get password => _t('password', 'Password', 'Пароль');
  String get login => _t('login', 'Log in', 'Войти');
  String get noAccount => _t('noAccount', "Don't have an account?", 'Нет аккаунта?');
  String get register => _t('register', 'Register', 'Зарегистрироваться');
  String get createAccount => _t('createAccount', 'Create account', 'Создать аккаунт');
  String get registerToStart => _t('registerToStart', 'Register to start your journey', 'Зарегистрируйся, чтобы начать путешествие');
  String get confirmPassword => _t('confirmPassword', 'Confirm password', 'Подтвердите пароль');
  String get haveAccount => _t('haveAccount', 'Already have an account?', 'Уже есть аккаунт?');
  String get enterEmail => _t('enterEmail', 'Enter your email', 'Введите почту');
  String get enterPassword => _t('enterPassword', 'Enter password', 'Введите пароль');
  String get passwordsDoNotMatch => _t('passwordsDoNotMatch', 'Passwords do not match', 'Пароли не совпадают');
  String get passwordTooShort => _t('passwordTooShort', 'Password must be at least 6 characters', 'Пароль должен быть не менее 6 символов');
  String get invalidEmail => _t('invalidEmail', 'Invalid email address', 'Неверный адрес почты');

  // Server errors
  String get serverUnavailable => _t('serverUnavailable', 'Server unavailable', 'Сервер недоступен');
  String get sessionExpired => _t('sessionExpired', 'Session expired. Please log in again', 'Сессия истекла. Войдите снова');
  String get tryAgainLater => _t('tryAgainLater', 'Please try again later', 'Попробуйте позже');
  String get networkError => _t('networkError', 'Network error. Check your connection', 'Ошибка сети. Проверьте соединение');

  // Sounds
  String get sounds => _t('sounds', 'Sounds', 'Звуки');
  String get soundsSubtitle => _t('soundsSubtitle', 'Nostalgic sounds from the past', 'Ностальгические звуки из прошлого');
  String get searchSounds => _t('searchSounds', 'Search sounds...', 'Поиск звуков...');
  String get noSoundsFound => _t('noSoundsFound', 'No sounds found', 'Звуки не найдены');
  String get tryDifferentSearch => _t('tryDifferentSearch', 'Try a different search', 'Попробуйте другой запрос');

  String _t(String key, String en, String ru) {
    return locale == 'ru' ? ru : en;
  }
}

// Provider for current locale
final localeProvider = StateNotifierProvider<LocaleNotifier, AppLocale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<AppLocale> {
  final _storage = const FlutterSecureStorage();

  LocaleNotifier() : super(AppLocale.en) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final saved = await _storage.read(key: 'app_locale');
    if (saved != null) {
      state = AppLocale.fromCode(saved);
    } else {
      // Use system locale
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      state = AppLocale.fromCode(systemLocale);
    }
  }

  Future<void> setLocale(AppLocale locale) async {
    state = locale;
    await _storage.write(key: 'app_locale', value: locale.code);
  }
}

// Provider for localized strings
final stringsProvider = Provider<AppStrings>((ref) {
  final locale = ref.watch(localeProvider);
  return AppStrings(locale.code);
});
