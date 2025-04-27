import 'dart:convert';
import 'package:http/http.dart' as http;
import 'services_config.dart';

class Resource {
  final String? id;
  final String type;
  final String link;

  Resource({
    this.id,
    required this.type,
    required this.link,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'],
      type: json['type'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'type': type,
      'link': link,
    };
  }
}

class ResourcesService {
  final String baseUrl;
  final http.Client _client;

  ResourcesService({
    String? baseUrl,
    http.Client? client,
  }) : 
    baseUrl = baseUrl ?? ServicesConfig.baseUrl,
    _client = client ?? http.Client();

  // Create a new resource for a school
  Future<Resource> createResource(String schoolId, Resource resource) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/schools/$schoolId/resources'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(resource.toJson()),
    );

    if (response.statusCode == 201) {
      return Resource.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create resource: ${response.body}');
    }
  }

  // Get a specific resource for a school
  Future<Resource> getResourceById(String schoolId, String resourceId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/schools/$schoolId/resources/$resourceId'),
    );

    if (response.statusCode == 200) {
      return Resource.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load resource: ${response.body}');
    }
  }

  // Get all resources for a school
  Future<List<Resource>> getAllResources(String schoolId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/schools/$schoolId/resources/'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> resourceList = jsonDecode(response.body);
      return resourceList.map((resourceData) => Resource.fromJson(resourceData)).toList();
    } else {
      throw Exception('Failed to load resources: ${response.body}');
    }
  }

  // Update a resource
  Future<Resource> updateResource(String schoolId, String resourceId, Resource resource) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/schools/$schoolId/resources/$resourceId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(resource.toJson()),
    );

    if (response.statusCode == 200) {
      return Resource.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update resource: ${response.body}');
    }
  }

  // Delete a resource
  Future<bool> deleteResource(String schoolId, String resourceId) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/schools/$schoolId/resources/$resourceId'),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete resource: ${response.body}');
    }
  }
  
  // Add multiple resources at once
  Future<List<Resource>> addMultipleResources(String schoolId, List<Resource> resources) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/schools/$schoolId/resources/batch'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(resources.map((r) => r.toJson()).toList()),
    );

    if (response.statusCode == 201) {
      final List<dynamic> resourceList = jsonDecode(response.body);
      return resourceList.map((resourceData) => Resource.fromJson(resourceData)).toList();
    } else {
      throw Exception('Failed to add resources: ${response.body}');
    }
  }
  
  // Search resources by type
  Future<List<Resource>> searchResourcesByType(String schoolId, String type) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/schools/$schoolId/resources/search?type=$type'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> resourceList = jsonDecode(response.body);
      return resourceList.map((resourceData) => Resource.fromJson(resourceData)).toList();
    } else {
      throw Exception('Failed to search resources: ${response.body}');
    }
  }
}
