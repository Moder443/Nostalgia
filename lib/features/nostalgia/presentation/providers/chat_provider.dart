import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/chat_service.dart';

enum ChatStatus { initial, waitingForAnswer, streaming, ready, error }

class ChatState {
  final ChatStatus status;
  final List<ChatMessage> messages;
  final String currentStreamingMessage;
  final String? error;
  final bool showChat;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.currentStreamingMessage = '',
    this.error,
    this.showChat = false,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessage>? messages,
    String? currentStreamingMessage,
    String? error,
    bool? showChat,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      currentStreamingMessage: currentStreamingMessage ?? this.currentStreamingMessage,
      error: error,
      showChat: showChat ?? this.showChat,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService _chatService;
  StreamSubscription<String>? _subscription;

  // Store context for the conversation
  String _nostalgiaContext = '';
  String _memoryQuestion = '';
  String _language = 'ru';

  ChatNotifier(this._chatService) : super(const ChatState());

  void initialize({
    required String nostalgiaContext,
    required String memoryQuestion,
    required String language,
  }) {
    _nostalgiaContext = nostalgiaContext;
    _memoryQuestion = memoryQuestion;
    _language = language;
    state = const ChatState(status: ChatStatus.waitingForAnswer);
  }

  void reset() {
    _subscription?.cancel();
    _nostalgiaContext = '';
    _memoryQuestion = '';
    state = const ChatState();
  }

  Future<void> sendAnswer(String answer) async {
    // Add user message
    final userMessage = ChatMessage(role: 'user', content: answer);
    final newMessages = [...state.messages, userMessage];

    state = state.copyWith(
      status: ChatStatus.streaming,
      messages: newMessages,
      currentStreamingMessage: '',
      showChat: true,
    );

    await _streamResponse(answer, newMessages);
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(role: 'user', content: message);
    final newMessages = [...state.messages, userMessage];

    state = state.copyWith(
      status: ChatStatus.streaming,
      messages: newMessages,
      currentStreamingMessage: '',
    );

    await _streamResponse(message, newMessages);
  }

  Future<void> _streamResponse(String userAnswer, List<ChatMessage> conversationHistory) async {
    try {
      String fullResponse = '';

      final stream = _chatService.streamChat(
        nostalgiaContext: _nostalgiaContext,
        memoryQuestion: _memoryQuestion,
        userAnswer: userAnswer,
        messages: conversationHistory.sublist(0, conversationHistory.length - 1), // Exclude current message
        language: _language,
      );

      await for (final chunk in stream) {
        fullResponse += chunk;
        state = state.copyWith(
          currentStreamingMessage: fullResponse,
        );
      }

      // Add AI response to messages
      final aiMessage = ChatMessage(role: 'assistant', content: fullResponse);
      state = state.copyWith(
        status: ChatStatus.ready,
        messages: [...state.messages, aiMessage],
        currentStreamingMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        status: ChatStatus.error,
        error: e.toString(),
        currentStreamingMessage: '',
      );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  return ChatNotifier(chatService);
});
