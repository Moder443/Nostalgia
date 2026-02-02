import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/models/sound.dart';

// Sample nostalgic sounds data with working URLs
final List<Sound> _sampleSounds = [
  Sound(
    id: '1',
    title: 'Nokia Tune',
    description: 'Классический рингтон Nokia. Звук из 2000-х, который помнит каждый.',
    category: 'phones',
    audioUrl: 'https://www.soundjay.com/phone/sounds/phone-calling-1.mp3',
    duration: Duration(seconds: 5),
    tags: ['nokia', 'телефон', 'рингтон', '2000-е'],
  ),
  Sound(
    id: '2',
    title: 'Windows Startup',
    description: 'Звук загрузки Windows. Ностальгия по первому компьютеру.',
    category: 'computers',
    audioUrl: 'https://www.soundjay.com/misc/sounds/magic-chime-01.mp3',
    duration: Duration(seconds: 3),
    tags: ['windows', 'компьютер', 'загрузка'],
  ),
  Sound(
    id: '3',
    title: 'Dial-up Modem',
    description: 'Звук подключения к интернету через модем. Помните это ожидание?',
    category: 'computers',
    audioUrl: 'https://upload.wikimedia.org/wikipedia/commons/3/33/Dial_up_modem_noises.ogg',
    duration: Duration(seconds: 25),
    tags: ['модем', 'интернет', 'dialup', '90-е'],
  ),
  Sound(
    id: '4',
    title: 'Сообщение',
    description: 'Звук входящего сообщения. Кто-то написал!',
    category: 'messengers',
    audioUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.mp3',
    duration: Duration(seconds: 2),
    tags: ['мессенджер', 'сообщение', '90-е'],
  ),
  Sound(
    id: '5',
    title: 'Игровой автомат',
    description: 'Звуки аркадных игровых автоматов из 90-х.',
    category: 'games',
    audioUrl: 'https://www.soundjay.com/misc/sounds/slot-machine-02.mp3',
    duration: Duration(seconds: 3),
    tags: ['аркада', 'игра', 'автомат', '90-е'],
  ),
  Sound(
    id: '6',
    title: 'Монетка',
    description: 'Звук собирания монетки в видеоигре.',
    category: 'games',
    audioUrl: 'https://www.soundjay.com/misc/sounds/coin-drop-1.mp3',
    duration: Duration(seconds: 1),
    tags: ['mario', 'игра', 'монетка'],
  ),
  Sound(
    id: '7',
    title: 'Механическая игрушка',
    description: 'Звуки заводной механической игрушки.',
    category: 'toys',
    audioUrl: 'https://www.soundjay.com/misc/sounds/cuckoo-clock-01.mp3',
    duration: Duration(seconds: 3),
    tags: ['игрушка', '90-е', 'заводная'],
  ),
  Sound(
    id: '8',
    title: 'Кассетный магнитофон',
    description: 'Звук нажатия кнопки Play на кассетнике.',
    category: 'media',
    audioUrl: 'https://www.soundjay.com/button/sounds/button-09.mp3',
    duration: Duration(seconds: 1),
    tags: ['кассета', 'магнитофон', 'play'],
  ),
  Sound(
    id: '9',
    title: 'Телевизионные помехи',
    description: 'Белый шум и помехи старого телевизора.',
    category: 'tv',
    audioUrl: 'https://www.soundjay.com/misc/sounds/tv-static-05.mp3',
    duration: Duration(seconds: 5),
    tags: ['тв', 'телевизор', 'помехи', 'шум'],
  ),
  Sound(
    id: '10',
    title: 'Школьный звонок',
    description: 'Звонок на урок или перемену. Сколько воспоминаний!',
    category: 'school',
    audioUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-01.mp3',
    duration: Duration(seconds: 4),
    tags: ['школа', 'звонок', 'урок', 'перемена'],
  ),
  Sound(
    id: '11',
    title: 'Печатная машинка',
    description: 'Звук печатной машинки - предка компьютера.',
    category: 'computers',
    audioUrl: 'https://www.soundjay.com/mechanical/sounds/typewriter-1.mp3',
    duration: Duration(seconds: 3),
    tags: ['печатная машинка', 'typing', 'ретро'],
  ),
  Sound(
    id: '12',
    title: 'Старый телефон',
    description: 'Звонок дискового телефона.',
    category: 'phones',
    audioUrl: 'https://www.soundjay.com/phone/sounds/old-telephone-ringing-01.mp3',
    duration: Duration(seconds: 5),
    tags: ['телефон', 'дисковый', 'звонок'],
  ),
];

final List<SoundCategory> _categories = [
  SoundCategory(id: 'all', name: 'Все', icon: '🎵'),
  SoundCategory(id: 'phones', name: 'Телефоны', icon: '📱'),
  SoundCategory(id: 'computers', name: 'Компьютеры', icon: '💻'),
  SoundCategory(id: 'games', name: 'Игры', icon: '🎮'),
  SoundCategory(id: 'messengers', name: 'Мессенджеры', icon: '💬'),
  SoundCategory(id: 'toys', name: 'Игрушки', icon: '🧸'),
  SoundCategory(id: 'media', name: 'Медиа', icon: '📼'),
  SoundCategory(id: 'tv', name: 'ТВ', icon: '📺'),
  SoundCategory(id: 'school', name: 'Школа', icon: '🏫'),
];

class SoundsState {
  final List<Sound> sounds;
  final List<Sound> filteredSounds;
  final List<SoundCategory> categories;
  final String selectedCategory;
  final String searchQuery;
  final String? currentlyPlayingId;
  final String? loadingId;
  final String? errorMessage;
  final bool isLoading;

  const SoundsState({
    this.sounds = const [],
    this.filteredSounds = const [],
    this.categories = const [],
    this.selectedCategory = 'all',
    this.searchQuery = '',
    this.currentlyPlayingId,
    this.loadingId,
    this.errorMessage,
    this.isLoading = false,
  });

  SoundsState copyWith({
    List<Sound>? sounds,
    List<Sound>? filteredSounds,
    List<SoundCategory>? categories,
    String? selectedCategory,
    String? searchQuery,
    String? currentlyPlayingId,
    String? loadingId,
    String? errorMessage,
    bool? isLoading,
    bool clearCurrentlyPlaying = false,
    bool clearLoading = false,
    bool clearError = false,
  }) {
    return SoundsState(
      sounds: sounds ?? this.sounds,
      filteredSounds: filteredSounds ?? this.filteredSounds,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      currentlyPlayingId: clearCurrentlyPlaying ? null : (currentlyPlayingId ?? this.currentlyPlayingId),
      loadingId: clearLoading ? null : (loadingId ?? this.loadingId),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SoundsNotifier extends StateNotifier<SoundsState> {
  AudioPlayer? _audioPlayer;

  SoundsNotifier() : super(const SoundsState()) {
    _loadSounds();
  }

  void _loadSounds() {
    state = state.copyWith(
      sounds: _sampleSounds,
      filteredSounds: _sampleSounds,
      categories: _categories,
    );
  }

  void selectCategory(String categoryId) {
    state = state.copyWith(selectedCategory: categoryId);
    _filterSounds();
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
    _filterSounds();
  }

  void _filterSounds() {
    var filtered = state.sounds;

    // Filter by category
    if (state.selectedCategory != 'all') {
      filtered = filtered.where((s) => s.category == state.selectedCategory).toList();
    }

    // Filter by search query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((s) {
        return s.title.toLowerCase().contains(query) ||
            s.description.toLowerCase().contains(query) ||
            s.tags.any((t) => t.toLowerCase().contains(query));
      }).toList();
    }

    state = state.copyWith(filteredSounds: filtered);
  }

  Future<void> playSound(Sound sound) async {
    // Stop current sound if playing
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
      await _audioPlayer!.dispose();
      _audioPlayer = null;
    }

    // If same sound, just stop
    if (state.currentlyPlayingId == sound.id) {
      state = state.copyWith(clearCurrentlyPlaying: true, clearLoading: true, clearError: true);
      return;
    }

    // Show loading state
    state = state.copyWith(
      loadingId: sound.id,
      clearCurrentlyPlaying: true,
      clearError: true,
    );

    // Play new sound
    _audioPlayer = AudioPlayer();

    try {
      await _audioPlayer!.setUrl(sound.audioUrl);

      _audioPlayer!.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          state = state.copyWith(clearCurrentlyPlaying: true, clearLoading: true);
        }
      });

      await _audioPlayer!.play();
      state = state.copyWith(
        currentlyPlayingId: sound.id,
        clearLoading: true,
      );
    } catch (e) {
      state = state.copyWith(
        clearCurrentlyPlaying: true,
        clearLoading: true,
        errorMessage: 'Не удалось воспроизвести звук',
      );
      _audioPlayer?.dispose();
      _audioPlayer = null;

      // Clear error after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (state.errorMessage != null) {
          state = state.copyWith(clearError: true);
        }
      });
    }
  }

  Future<void> stopSound() async {
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
      state = state.copyWith(clearCurrentlyPlaying: true);
    }
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }
}

final soundsProvider = StateNotifierProvider<SoundsNotifier, SoundsState>((ref) {
  return SoundsNotifier();
});
