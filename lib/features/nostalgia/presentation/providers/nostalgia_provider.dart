import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/models/nostalgia_generation.dart';

class DailyNostalgiaState {
  final NostalgiaGeneration? generation;
  final bool isLoading;
  final String? error;

  const DailyNostalgiaState({
    this.generation,
    this.isLoading = false,
    this.error,
  });

  DailyNostalgiaState copyWith({
    NostalgiaGeneration? generation,
    bool? isLoading,
    String? error,
  }) {
    return DailyNostalgiaState(
      generation: generation ?? this.generation,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DailyNostalgiaNotifier extends StateNotifier<DailyNostalgiaState> {
  final ApiClient _apiClient;

  DailyNostalgiaNotifier(this._apiClient) : super(const DailyNostalgiaState());

  Future<void> fetchDaily({bool regenerate = true, String language = 'ru'}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Always generate new content on button press
      final response = await _apiClient.getDailyNostalgia(
        regenerate: regenerate,
        language: language,
      );
      final generation = NostalgiaGeneration.fromJson(response.data);

      state = state.copyWith(
        generation: generation,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: language == 'ru' ? 'Не удалось загрузить' : 'Failed to load',
      );
    }
  }
}

final dailyNostalgiaProvider =
    StateNotifierProvider<DailyNostalgiaNotifier, DailyNostalgiaState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DailyNostalgiaNotifier(apiClient);
});

// History provider
class NostalgiaHistoryState {
  final List<NostalgiaHistoryItem> items;
  final bool isLoading;
  final bool hasMore;
  final int total;
  final String? error;

  const NostalgiaHistoryState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.total = 0,
    this.error,
  });

  NostalgiaHistoryState copyWith({
    List<NostalgiaHistoryItem>? items,
    bool? isLoading,
    bool? hasMore,
    int? total,
    String? error,
  }) {
    return NostalgiaHistoryState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      total: total ?? this.total,
      error: error,
    );
  }
}

class NostalgiaHistoryNotifier extends StateNotifier<NostalgiaHistoryState> {
  final ApiClient _apiClient;

  NostalgiaHistoryNotifier(this._apiClient) : super(const NostalgiaHistoryState());

  Future<void> fetchHistory({bool refresh = false}) async {
    if (state.isLoading) return;
    if (!refresh && !state.hasMore) return;

    final offset = refresh ? 0 : state.items.length;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.getNostalgiaHistory(
        limit: 10,
        offset: offset,
      );

      final newItems = (response.data['items'] as List)
          .map((json) => NostalgiaHistoryItem.fromJson(json))
          .toList();

      state = state.copyWith(
        items: refresh ? newItems : [...state.items, ...newItems],
        isLoading: false,
        hasMore: response.data['has_more'] ?? false,
        total: response.data['total'] ?? 0,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load history',
      );
    }
  }

  Future<bool> deleteNostalgia(String id) async {
    try {
      await _apiClient.deleteNostalgia(id);
      // Remove from local state
      state = state.copyWith(
        items: state.items.where((item) => item.id != id).toList(),
        total: state.total > 0 ? state.total - 1 : 0,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}

final nostalgiaHistoryProvider =
    StateNotifierProvider<NostalgiaHistoryNotifier, NostalgiaHistoryState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NostalgiaHistoryNotifier(apiClient);
});
