import 'package:flutter_riverpod/flutter_riverpod.dart';

// Chat Message State Provider
final chatMessagesProvider = StateNotifierProvider<ChatNotifier, List<String>>(
  (ref) => ChatNotifier(),
);

class ChatNotifier extends StateNotifier<List<String>> {
  ChatNotifier() : super([]);

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      state = [...state, message]; // Append new message
    }
  }
}
