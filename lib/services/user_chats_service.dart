import 'dart:convert';
import 'package:http/http.dart' as http;
import 'services_config.dart';

class Message {
  final String content;
  final String sender;

  Message({
    required this.content,
    required this.sender,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      sender: json['sender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'sender': sender,
    };
  }
}

class UserChat {
  final int? chatId;
  final String userId;
  final List<Message> messages;
  final DateTime date;

  UserChat({
    this.chatId,
    required this.userId,
    required this.messages,
    required this.date,
  });

  factory UserChat.fromJson(Map<String, dynamic> json) {
    return UserChat(
      chatId: json['chat_id'],
      userId: json['user_id'],
      messages: (json['messages'] as List)
          .map((messageJson) => Message.fromJson(messageJson))
          .toList(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (chatId != null) 'chat_id': chatId,
      'user_id': userId,
      'messages': messages.map((message) => message.toJson()).toList(),
      'date': date.toIso8601String(),
    };
  }
}

class UserChatsService {
  final String baseUrl;
  final http.Client _client;

  UserChatsService({
    String? baseUrl,
    http.Client? client,
  }) : 
    baseUrl = baseUrl ?? ServicesConfig.baseUrl,
    _client = client ?? http.Client();

  // Create a new chat for a user
  Future<UserChat> createChat(String userId, UserChat chat) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/users/$userId/chats'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(chat.toJson()),
    );

    if (response.statusCode == 201) {
      return UserChat.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create chat: ${response.body}');
    }
  }

  // Get a specific chat for a user
  Future<UserChat> getChatById(String userId, int chatId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/users/$userId/chats/$chatId'),
    );

    if (response.statusCode == 200) {
      return UserChat.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load chat: ${response.body}');
    }
  }

  // Get all chats for a user
  Future<List<UserChat>> getAllChats(String userId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/users/$userId/chats'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> chatList = jsonDecode(response.body);
      return chatList.map((chatData) => UserChat.fromJson(chatData)).toList();
    } else {
      throw Exception('Failed to load chats: ${response.body}');
    }
  }

  // Update a chat
  Future<UserChat> updateChat(String userId, int chatId, UserChat chat) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/users/$userId/chats/$chatId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(chat.toJson()),
    );

    if (response.statusCode == 200) {
      return UserChat.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update chat: ${response.body}');
    }
  }

  // Delete a chat
  Future<bool> deleteChat(String userId, int chatId) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/users/$userId/chats/$chatId'),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete chat: ${response.body}');
    }
  }

  // Add a message to a chat
  Future<UserChat> addMessage(String userId, int chatId, Message message) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/users/$userId/chats/$chatId/messages'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return UserChat.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add message: ${response.body}');
    }
  }
}
