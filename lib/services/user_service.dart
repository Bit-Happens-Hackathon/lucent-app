import 'dart:convert';
import 'package:http/http.dart' as http;
import 'services_config.dart';

class User {
  final String? id;
  final String name;
  final String email;
  final DateTime birthdate;
  final String school;
  final String? password;
  final String? createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.birthdate,
    required this.school,
    this.password,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      birthdate: DateTime.parse(json['birthdate']),
      school: json['school'],
      password: json['password'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'birthdate': birthdate.toIso8601String().split('T')[0],
      'school': school,
      if (password != null) 'password': password,
      if (createdAt != null) 'created_at': createdAt,
    };
  }
}

class UserService {
  final String baseUrl;
  final http.Client _client;

  UserService({
    String? baseUrl,
    http.Client? client,
  }) : 
    baseUrl = baseUrl ?? ServicesConfig.baseUrl,
    _client = client ?? http.Client();

  // Create a new user
  Future<User> createUser(User user, {String? confirmPassword}) async {
    final userData = user.toJson();
    
    // Add confirm_password field for registration if provided
    if (confirmPassword != null) {
      userData['confirm_password'] = confirmPassword;
    }
    
    final response = await _client.post(
      Uri.parse('$baseUrl/users/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user: ${response.body}');
    }
  }

  // Get a user by ID
  Future<User> getUserById(String id) async {
    final response = await _client.get(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user: ${response.body}');
    }
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    final response = await _client.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> userList = jsonDecode(response.body);
      return userList.map((userData) => User.fromJson(userData)).toList();
    } else {
      throw Exception('Failed to load users: ${response.body}');
    }
  }

  // Update a user
  Future<User> updateUser(String id, User user) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  // Delete a user
  Future<bool> deleteUser(String id) async {
    final response = await _client.delete(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete user: ${response.body}');
    }
  }
  
  // Search users by name or email
  Future<List<User>> searchUsers(String query) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/users/search?query=$query'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> userList = jsonDecode(response.body);
      return userList.map((userData) => User.fromJson(userData)).toList();
    } else {
      throw Exception('Failed to search users: ${response.body}');
    }
  }
}
