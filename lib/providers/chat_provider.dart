import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../models/chat_model.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

class ChatState {
  final List<ChatSessionModel> sessions;
  final ChatSessionModel? activeSession;
  final List<ChatMessageModel> activeMessages;
  final bool isLoading;
  final bool isStreaming;
  final String? error;

  ChatState({
    this.sessions = const [],
    this.activeSession,
    this.activeMessages = const [],
    this.isLoading = false,
    this.isStreaming = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatSessionModel>? sessions,
    ChatSessionModel? activeSession,
    List<ChatMessageModel>? activeMessages,
    bool? isLoading,
    bool? isStreaming,
    String? error,
  }) {
    return ChatState(
      sessions: sessions ?? this.sessions,
      activeSession: activeSession ?? this.activeSession,
      activeMessages: activeMessages ?? this.activeMessages,
      isLoading: isLoading ?? this.isLoading,
      isStreaming: isStreaming ?? this.isStreaming,
      error: error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState()) {
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await DioClient.instance.get('/chat/sessions');
      final sessions = (response.data as List)
          .map((json) => ChatSessionModel.fromJson(json))
          .toList();
      state = state.copyWith(isLoading: false, sessions: sessions);
      if (sessions.isNotEmpty && state.activeSession == null) {
        await loadSession(sessions.first.id);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load sessions');
    }
  }

  Future<void> createNewSession() async {
    try {
      final response = await DioClient.instance.post(
        '/chat/sessions',
        data: {'title': 'New Conversation', 'language': 'en'},
      );
      final newSession = ChatSessionModel.fromJson(response.data);
      state = state.copyWith(
        sessions: [newSession, ...state.sessions],
        activeSession: newSession,
        activeMessages: [],
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to create session');
    }
  }

  Future<void> loadSession(int sessionId) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await DioClient.instance.get('/chat/sessions/$sessionId');
      final session = ChatSessionModel.fromJson(response.data);
      final messages = (response.data['messages'] as List)
          .map((json) => ChatMessageModel.fromJson(json))
          .toList();
      state = state.copyWith(
        isLoading: false,
        activeSession: session,
        activeMessages: messages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load chat history');
    }
  }

  Future<void> sendMessage(String text) async {
    if (state.activeSession == null) {
      await createNewSession();
    }

    final sessionId = state.activeSession!.id;

    // Optimistically add user message and empty AI message
    final userMsg = ChatMessageModel(role: 'user', content: text);
    final aiMsg = ChatMessageModel(role: 'assistant', content: '');
    
    state = state.copyWith(
      activeMessages: [...state.activeMessages, userMsg, aiMsg],
      isStreaming: true,
    );

    try {
      final response = await DioClient.instance.post(
        '/chat/sessions/$sessionId/messages/stream',
        data: {'message': text, 'language': 'en', 'stream': true},
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data.stream as Stream<List<int>>;
      
      await for (final chunk in stream) {
        final decodedChunk = utf8.decode(chunk);
        final lines = decodedChunk.split('\n');
        
        for (final line in lines) {
          if (line.startsWith('data: ')) {
            final dataStr = line.substring(6).trim();
            if (dataStr.isEmpty) continue;
            
            final data = jsonDecode(dataStr);
            if (data['done'] == true) {
              state = state.copyWith(isStreaming: false);
              return; // Done
            } else if (data['token'] != null) {
              // Update last message
              final messages = List<ChatMessageModel>.from(state.activeMessages);
              final last = messages.last;
              messages[messages.length - 1] = last.copyWith(
                content: last.content + data['token'],
              );
              state = state.copyWith(activeMessages: messages);
            }
          }
        }
      }
    } catch (e) {
      state = state.copyWith(isStreaming: false, error: 'Failed to send message');
    }
  }
}
