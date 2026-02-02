import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => debugPrint(obj.toString()),
    ));
  }

  // Nostalgia endpoints
  Future<Response> getDailyNostalgia({bool regenerate = false, String language = 'ru'}) async {
    return _dio.get('/nostalgia/daily', queryParameters: {
      if (regenerate) 'regenerate': 'true',
      'language': language,
    });
  }

  Future<Response> getNostalgiaHistory({int limit = 10, int offset = 0}) async {
    return _dio.get('/nostalgia/history', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
  }

  Future<Response> getNostalgiaById(String id) async {
    return _dio.get('/nostalgia/$id');
  }

  Future<Response> deleteNostalgia(String id) async {
    return _dio.delete('/nostalgia/$id');
  }

  // Chat streaming endpoint - returns the stream URL for SSE
  String getChatStreamUrl() {
    return '${AppConfig.apiBaseUrl}/chat/stream';
  }
}
