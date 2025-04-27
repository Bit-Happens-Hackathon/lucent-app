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

  Future<LLMMessage> sendMessage(String message, String user_id,
      {int? chat_id}) async {
    String endpoint;

    // Use the correct endpoint - appears the /chat endpoint is what works
    endpoint = '${ServicesConfig.baseUrl}/users/$user_id/chat';

    var body = {
      'prompt': message,
    };

    // Add chat_id to body if it's provided
    if (chat_id != null) {
      body['chat_id'] = chat_id.toString();
    }

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final jsonData = jsonDecode(response.body);

          // Clean the response text
          String cleanedResponse = "";
          if (jsonData['response'] != null) {
            cleanedResponse = _cleanText(jsonData['response']);
          }

          // Parse chat_id appropriately
          int chatId = 0;
          if (jsonData['chat_id'] != null) {
            chatId = jsonData['chat_id'] is String
                ? int.tryParse(jsonData['chat_id']) ?? 0
                : jsonData['chat_id'];
          }

          // Handle school_sources or school_resources (whichever the API returns)
          List<String> schoolSources = [];
          if (jsonData['school_sources'] != null) {
            schoolSources = List<String>.from(jsonData['school_sources']);
          } else if (jsonData['school_resources'] != null) {
            schoolSources = List<String>.from(jsonData['school_resources']);
          }

          return LLMMessage(
            response: cleanedResponse, // Use the cleaned response
            chat_id: chatId, // Use the parsed chat_id
            school_sources: schoolSources, // Use the properly handled sources
          );
        } catch (e) {
          print('Error parsing response JSON: $e');
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception(
            'Failed to send message: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in sendMessage: $e');
      throw e;
    }
  }
}

String _cleanText(String text) {
  // Replace problematic characters
  final cleanedText = text
    .replaceAll('\u00a0', ' ')     // Non-breaking space
    .replaceAll('\u2019', "'")     // Right single quotation mark
    .replaceAll('\u2018', "'")     // Left single quotation mark
    .replaceAll('\u2032', "'")     // Prime (another apostrophe variant)
    .replaceAll('\u02BC', "'")     // Modifier letter apostrophe
    .replaceAll('\u02BB', "'")     // Modifier letter turned comma
    .replaceAll('\u201C', "\"")    // Left double quotation mark
    .replaceAll('\u201D', "\"")    // Right double quotation mark
    .replaceAll('\u2013', "-")     // En dash
    .replaceAll('\u2014', "--")    // Em dash
    .replaceAll('—', "--")         // Another em dash character
    .replaceAll('\u2026', "...")   // Ellipsis
    .replaceAll('\u00E2\u0080\u0099', "'") // UTF-8 apostrophe sequence
    .replaceAll('â', "'")          // Specifically replace â that often appears instead of apostrophe
    .replaceAll('â\u0080\u0099', "'") // Another common apostrophe issue
    .replaceAll('\r\n', '\n')      // Normalize line breaks
    .replaceAll('\r', '\n');
    
  return cleanedText;
}
class LLMMessage {
  final String response;
  final int chat_id;
  final List<String> school_sources;

  LLMMessage({
    required this.response,
    required this.chat_id,
    required this.school_sources,
  });

  factory LLMMessage.fromJson(Map<String, dynamic> json) {
    // Properly handle the chat_id that could be either a string or an int
    int chatId = 0;
    if (json['chat_id'] != null) {
      chatId = json['chat_id'] is String
          ? int.tryParse(json['chat_id']) ?? 0
          : json['chat_id'];
    }

    return LLMMessage(
      response: json['response'] ?? '',
      chat_id: chatId, // Use the parsed chat_id
      school_sources: json['school_sources'] != null
          ? List<String>.from(json['school_sources'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'chat_id': chat_id,
      'school_sources': school_sources,
    };
  }
}
