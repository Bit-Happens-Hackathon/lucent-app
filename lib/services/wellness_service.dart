import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'services_config.dart';

/// Model class for wellness records
class WellnessRecord {
  final int? wellnessId;
  final String userId;
  final DateTime date;
  final int physical;
  final int financial;
  final int emotional;
  final int spiritual;
  final int social;
  final int environmental;
  final int creative;

  WellnessRecord({
    this.wellnessId,
    required this.userId,
    required this.date,
    required this.physical,
    required this.financial,
    required this.emotional,
    required this.spiritual,
    required this.social,
    required this.environmental,
    required this.creative,
  });

  /// Create a WellnessRecord from JSON data
  factory WellnessRecord.fromJson(Map<String, dynamic> json) {
    return WellnessRecord(
      wellnessId: json['wellness_id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      physical: json['physical'],
      financial: json['financial'],
      emotional: json['emotional'],
      spiritual: json['spiritual'],
      social: json['social'],
      environmental: json['environmental'],
      creative: json['creative'],
    );
  }

  /// Convert WellnessRecord to JSON
  Map<String, dynamic> toJson() {
    return {
      if (wellnessId != null) 'wellness_id': wellnessId,
      'user_id': userId,
      'record_date': DateFormat('yyyy-MM-dd').format(date),
      'physical': physical,
      'financial': financial,
      'emotional': emotional,
      'spiritual': spiritual,
      'social': social,
      'environmental': environmental,
      'creative': creative,
    };
  }

  /// Create a copy of the record with updated fields
  WellnessRecord copyWith({
    int? wellnessId,
    String? userId,
    DateTime? date,
    int? physical,
    int? financial,
    int? emotional,
    int? spiritual,
    int? social,
    int? environmental,
    int? creative,
  }) {
    return WellnessRecord(
      wellnessId: wellnessId ?? this.wellnessId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      physical: physical ?? this.physical,
      financial: financial ?? this.financial,
      emotional: emotional ?? this.emotional,
      spiritual: spiritual ?? this.spiritual,
      social: social ?? this.social,
      environmental: environmental ?? this.environmental,
      creative: creative ?? this.creative,
    );
  }

  /// Calculate the average wellness score across all dimensions
  double get averageScore {
    return (physical + financial + emotional + spiritual + social + environmental + creative) / 7.0;
  }
}

/// Service for interacting with the wellness API
class WellnessService {
  final String baseUrl;
  final http.Client _client;

  WellnessService({
    String? baseUrl,
    http.Client? client,
  }) : 
    baseUrl = baseUrl ?? ServicesConfig.baseUrl,
    _client = client ?? http.Client();

  /// Create a new wellness record
  Future<WellnessRecord> createWellnessRecord(WellnessRecord record) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/wellness/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(record.toJson()),
    );

    if (response.statusCode == 201) {
      return WellnessRecord.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create wellness record: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createWellness(String userId, Map<String, dynamic> wellnessData) async {
  try {
    final uri = Uri.parse('$baseUrl/wellness/');
    // Prepare data for API request
    final requestData = {
      'user_id': userId,
      'physical': wellnessData['physical'],
      'financial': wellnessData['financial'],
      'emotional': wellnessData['emotional'],
      'spiritual': wellnessData['spiritual'],
      'social': wellnessData['social'],
      'environmental': wellnessData['environmental'],
      'creative': wellnessData['creative'],
    };
    
    if (kDebugMode) {
      print('Creating wellness record: ${uri.toString()}');
      print('Request data: $requestData');
    }
    
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );
    
    
    final responseData = json.decode(response.body);
    return responseData;
    
  } catch (e) {
    if (kDebugMode) {
      print('Exception during createWellness: $e');
    }
    throw Exception('Error creating wellness record: $e');
  }
}


  /// Get a specific wellness record by ID
  Future<WellnessRecord> getWellnessRecordById(int wellnessId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/wellness/$wellnessId'),
    );

    if (response.statusCode == 200) {
      return WellnessRecord.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get wellness record: ${response.body}');
    }
  }

  /// Get wellness records for a specific user
  Future<List<WellnessRecord>> getUserWellnessRecords({
    required String userId,
    int limit = 100,
    int offset = 0,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Build the query parameters
    final queryParams = {
      'limit': limit.toString(),
      'offset': offset.toString(),
      if (startDate != null) 'start_date': DateFormat('yyyy-MM-dd').format(startDate),
      if (endDate != null) 'end_date': DateFormat('yyyy-MM-dd').format(endDate),
    };

    // Construct the URL with query parameters
    final uri = Uri.parse('$baseUrl/wellness/user/$userId').replace(
      queryParameters: queryParams,
    );

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> recordsList = jsonDecode(response.body);
      return recordsList.map((record) => WellnessRecord.fromJson(record)).toList();
    } else {
      throw Exception('Failed to get user wellness records: ${response.body}');
    }
  }

  /// Update an existing wellness record
  Future<WellnessRecord> updateWellnessRecord(int wellnessId, WellnessRecord record) async {
    // Create the update payload (only including fields that can be updated)
    final updateData = {
      if (record.date != null) 'record_date': DateFormat('yyyy-MM-dd').format(record.date),
      'physical': record.physical,
      'financial': record.financial,
      'emotional': record.emotional,
      'spiritual': record.spiritual,
      'social': record.social,
      'environmental': record.environmental,
      'creative': record.creative,
    };

    final response = await _client.put(
      Uri.parse('$baseUrl/wellness/$wellnessId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      return WellnessRecord.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update wellness record: ${response.body}');
    }
  }

  /// Delete a wellness record
  Future<WellnessRecord> deleteWellnessRecord(int wellnessId) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/wellness/$wellnessId'),
    );

    if (response.statusCode == 200) {
      return WellnessRecord.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete wellness record: ${response.body}');
    }
  }
}