import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';

class ChatMessage {
  final String role;
  final String content;

  ChatMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    role: json['role'] as String,
    content: json['content'] as String,
  );
}

class ChatService {
  final String baseUrl = AppConfig.apiBaseUrl;

  /// Streams chat response from the server
  /// Returns a stream of text chunks
  Stream<String> streamChat({
    required String nostalgiaContext,
    required String memoryQuestion,
    required String userAnswer,
    required List<ChatMessage> messages,
    required String language,
  }) async* {
    final url = Uri.parse('$baseUrl/chat/stream');

    final body = jsonEncode({
      'nostalgia_context': nostalgiaContext,
      'memory_question': memoryQuestion,
      'user_answer': userAnswer,
      'messages': messages.map((m) => m.toJson()).toList(),
      'language': language,
    });

    final request = http.Request('POST', url);
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'text/event-stream';
    request.body = body;

    try {
      final client = http.Client();
      final response = await client.send(request);

      if (response.statusCode != 200) {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Chat request failed: $responseBody');
      }

      // Process SSE stream
      String buffer = '';
      await for (final chunk in response.stream.transform(utf8.decoder)) {
        buffer += chunk;

        // Process complete lines
        while (buffer.contains('\n')) {
          final newlineIndex = buffer.indexOf('\n');
          final line = buffer.substring(0, newlineIndex).trim();
          buffer = buffer.substring(newlineIndex + 1);

          if (line.isEmpty) continue;
          if (line == 'data: [DONE]') {
            client.close();
            return;
          }

          if (line.startsWith('data: ')) {
            final jsonStr = line.substring(6);
            try {
              final data = jsonDecode(jsonStr) as Map<String, dynamic>;
              if (data.containsKey('content')) {
                yield data['content'] as String;
              }
              if (data.containsKey('error')) {
                throw Exception(data['error']);
              }
            } catch (e) {
              if (e is! FormatException) {
                rethrow;
              }
              // Skip malformed JSON
              debugPrint('Skipping malformed chunk: $jsonStr');
            }
          }
        }
      }

      client.close();
    } catch (e) {
      debugPrint('Chat stream error: $e');
      rethrow;
    }
  }
}
