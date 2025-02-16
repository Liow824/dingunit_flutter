import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/nav/session_manager.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.0.105:8000/dingunit_backend";

  //  User Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Debug: Log the request details
      // debugPrint("Preparing to send request to: ${Uri.parse('$baseUrl/login/')}");
      // debugPrint("Request headers: {'Content-Type': 'application/x-www-form-urlencoded'}");
      // debugPrint("Request body: email=$email, password=$password");
      
      // Send the POST request
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      // Debug: Log the response status and body
      // debugPrint("Request sent successfully");
      // debugPrint("Response status: ${response.statusCode}");
      // debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        // Decode the JSON response
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Check if the status_code is 0 (success)
        if (data['status_code'] == 0) {
          return {
            'status': true,
            'message': data['message'], // Success message
            'guid': data['data']['GUID'], // User GUID
          };
        } else {
          return {
            'status': false,
            'message': data['message'], // Failure message from backend
          };
        }
      } else {
        // Handle non-200 HTTP responses
        debugPrint("Error: Received HTTP ${response.statusCode}");
        throw Exception("Failed to connect to the server. HTTP ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("HTTP request failed: $e");
      if (e is http.ClientException) {
        debugPrint("ClientException details: ${e.message}");
      }
      // Rethrow the exception to be handled by the caller
      throw Exception("An error occurred during the request: $e");
    }
  }

  //  User Registration
  static Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'), 
      body: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

  // Get user information
  static Future<Map<String, dynamic>> getUserDetails(String userGuid) async {
    try {
      debugPrint("Fetching user details for GUID: $userGuid");

      final response = await http.post(
        Uri.parse('$baseUrl/get_user_details/'), // Make sure the URL matches your backend
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'guid': userGuid, // Send GUID in the request body
        },
      );

      // Debug logs
      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data; // Return only the data object
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (e) {
      debugPrint("Error fetching user details: $e");
      throw Exception("An error occurred: $e");
    }
  }

  //  Update User Status
  static Future<Map<String, dynamic>> updateUserStatus(String userId, int newStatus) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update_accRight/'),
      body: {
        'admin_guid': SessionManager.currentUserGuid!,
        'user_guid': userId,
        'new_access_right': newStatus.toString(),
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user status');
    }
  }

  //  Delete User (Now added in backend)
  static Future<Map<String, dynamic>> deleteUser(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete_user/'),
      body: {
        'admin_guid': SessionManager.currentUserGuid!,        
        'user_guid': userId,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete user');
    }
  }


  static Future<Map<String, dynamic>> getUsersList({
    required int pageStart,
    required int pageSize,
    required String searchTerm,
  }) async {
    final uri = Uri.parse('$baseUrl/users/')
        .replace(queryParameters: {
      'page_start': pageStart.toString(),
      'page_size': pageSize.toString(),
      'search_term': searchTerm,
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'status_code': -1,
          'message': 'Failed to load users. Server error.'
        };
      }
    } catch (e) {
      return {
        'status_code': -1,
        'message': 'Failed to load users. Network error: $e'
      };
    }
  }


}

