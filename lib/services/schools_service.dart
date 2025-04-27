import 'dart:convert';
import 'package:http/http.dart' as http;
import 'services_config.dart';

class School {
  final String name;

  School({
    required this.name,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class SchoolsService {
  final String baseUrl;
  final http.Client _client;

  SchoolsService({
    String? baseUrl,
    http.Client? client,
  }) : 
    baseUrl = baseUrl ?? ServicesConfig.baseUrl,
    _client = client ?? http.Client();

  // Create a new school
  Future<School> createSchool(School school) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/schools/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(school.toJson()),
    );

    if (response.statusCode == 201) {
      return School.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create school: ${response.body}');
    }
  }

  // Get a school by name
  Future<School> getSchoolByName(String name) async {
    final response = await _client.get(Uri.parse('$baseUrl/schools/$name'));

    if (response.statusCode == 200) {
      return School.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load school: ${response.body}');
    }
  }

  // Get all schools
  Future<List<School>> getAllSchools() async {
    final response = await _client.get(Uri.parse('$baseUrl/schools'));

    if (response.statusCode == 200) {
      final List<dynamic> schoolList = jsonDecode(response.body);
      return schoolList.map((schoolData) => School.fromJson(schoolData)).toList();
    } else {
      throw Exception('Failed to load schools: ${response.body}');
    }
  }

  // Update a school
  Future<School> updateSchool(String name, School school) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/schools/$name'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(school.toJson()),
    );

    if (response.statusCode == 200) {
      return School.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update school: ${response.body}');
    }
  }

  // Delete a school
  Future<bool> deleteSchool(String name) async {
    final response = await _client.delete(Uri.parse('$baseUrl/schools/$name'));

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete school: ${response.body}');
    }
  }
  
  // Search schools by name
  Future<List<School>> searchSchools(String query) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/schools/search?query=$query'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> schoolList = jsonDecode(response.body);
      return schoolList.map((schoolData) => School.fromJson(schoolData)).toList();
    } else {
      throw Exception('Failed to search schools: ${response.body}');
    }
  }
}
