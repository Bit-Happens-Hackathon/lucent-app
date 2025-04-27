import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'services_config.dart';

class VisitsService {
  final String baseUrl = ServicesConfig.baseUrl;

  /// Fetches a list of visit dates for a specific user
  /// 
  /// [userId] - The user ID (email) for which to fetch visits
  /// [limit] - Optional limit for the number of visits to return (default: 365)
  /// [offset] - Optional offset for pagination (default: 0)
  /// 
  /// Returns a list of DateTime objects representing visit dates
  Future<List<DateTime>> getUserVisits(String userId, {int limit = 365, int offset = 0}) async {
    try {
      final uri = Uri.parse('$baseUrl/activity/user/$userId')
          .replace(queryParameters: {
            'limit': limit.toString(),
            'offset': offset.toString(),
          });
      
      if (kDebugMode) {
        print('Requesting: ${uri.toString()}');
      }
      
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // The response is now a list of activity objects
        final List<dynamic> activities = json.decode(response.body);
        
        // Extract login dates from activity objects
        return activities
            .where((activity) => activity['login'] != null)
            .map<DateTime>((activity) => DateTime.parse(activity['login']))
            .toList();
      } else {
        if (kDebugMode) {
          print('Error response: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw Exception('Failed to load visits: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during getUserVisits: $e');
      }
      throw Exception('Error fetching user visits: $e');
    }
  }

  /// Get the raw JSON response for user visits
  /// 
  /// [userId] - The user ID (email) for which to fetch visits
  /// [limit] - Optional limit for the number of visits to return (default: 365)
  /// [offset] - Optional offset for pagination (default: 0)
  Future<List<dynamic>> getRawUserVisits(String userId, {int limit = 365, int offset = 0}) async {
    try {
      final uri = Uri.parse('$baseUrl/activity/user/$userId')
          .replace(queryParameters: {
            'limit': limit.toString(),
            'offset': offset.toString(),
          });
      
      if (kDebugMode) {
        print('Requesting: ${uri.toString()}');
      }
      
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        if (kDebugMode) {
          print('Error response: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw Exception('Failed to load visits: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during getRawUserVisits: $e');
      }
      throw Exception('Error fetching user visits: $e');
    }
  }
  
  /// Creates a new visit record for a user
  /// 
  /// [userId] - The user ID (email) for which to create the visit
  /// [login] - Optional login datetime (defaults to current time)
  /// 
  /// Returns the created visit data
  Future<Map<String, dynamic>> createVisit(String userId, {DateTime? login}) async {
    try {
      final visitData = {
        'user_id': userId,
        'login': login?.toUtc().toIso8601String() ?? DateTime.now().toUtc().toIso8601String(),
      };
      
      if (kDebugMode) {
        print('Creating visit: $visitData');
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/activity/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(visitData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        if (kDebugMode) {
          print('Error response: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw Exception('Failed to create visit: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during createVisit: $e');
      }
      throw Exception('Error creating visit: $e');
    }
  }
}
