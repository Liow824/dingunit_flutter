import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/nav/session_manager.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:8000/dingunit_backend";

  // ======================  User ======================

  //  Login
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
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

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status_code'] == 0) {
          return {
            'status': true,
            'message': data['message'],
            'guid': data['data']['GUID'],
          };
        } else {
          return {
            'status': false,
            'message': data['message'],
          };
        }
      } else {
        throw Exception(
            "Failed to connect to the server. HTTP ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("HTTP request failed: $e");
      if (e is http.ClientException) {
        debugPrint("ClientException details: ${e.message}");
      }
      throw Exception("An error occurred during the request: $e");
    }
  }

  //  Registration
  static Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
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

  //  Get user information
  static Future<Map<String, dynamic>> getUserDetails(String userGuid) async {
    try {
      debugPrint("Fetching user details for GUID: $userGuid");

      final response = await http.post(
        Uri.parse(
            '$baseUrl/get_user_details/'), // Make sure the URL matches your backend
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'guid': userGuid, // Send GUID in the request body
        },
      );

      // Debug logs
      // debugPrint("Response status: ${response.statusCode}");
      // debugPrint("Response body: ${response.body}");

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

  //  Update Access Right
  static Future<Map<String, dynamic>> updateUserStatus(
      String userId, int newStatus) async {
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

  //  Delete user
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

  //  Print user list
  static Future<Map<String, dynamic>> getUsersList({
    required int pageStart,
    required int pageSize,
    required String searchTerm,
  }) async {
    final uri = Uri.parse('$baseUrl/users/').replace(queryParameters: {
      'page_start': pageStart.toString(),
      'page_size': pageSize.toString(),
      'search_term': searchTerm,
    });

    try {
      final response = await http.get(uri);

      // Debugging: Log the response
      debugPrint("Fetching user list from: $uri");
      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Extract Message and Response Code
        String message = data['message'] ?? 'No message from server';
        int responseCode = data['status_code'] ?? -1;

        // Check if response is successful
        if (responseCode == 0) {
          // Ensure 'data' exists and remove the first two fields (Message & Response)
          if (data.containsKey('data') && data['data'] is List) {
            List<Map<String, dynamic>> userList =
                List<Map<String, dynamic>>.from(data['data']);

            return {
              'status': true,
              'message': message,
              'users': userList, // Extract actual users
            };
          } else {
            return {
              'status': false,
              'message': 'Invalid response format: No user list found.',
              'users': [],
            };
          }
        } else {
          return {
            'status': false,
            'message': message,
            'users': [],
          };
        }
      } else {
        return {
          'status': false,
          'message': 'Failed to load users. Server error.',
          'users': [],
        };
      }
    } catch (e) {
      debugPrint("Error fetching users: $e");
      return {
        'status': false,
        'message': 'Failed to load users. Network error: $e',
        'users': [],
      };
    }
  }

  // ======================  Draft Management  ======================

  //  Get Draft List
  static Future<Map<String, dynamic>> getDraftList(String authorGuid) async {
    final uri = Uri.parse('$baseUrl/get_draft_list/')
        .replace(queryParameters: {'author_guid': authorGuid});

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status_code'] == 0) {
          return {
            'status': true,
            'message': data['message'],
            'drafts': data['data'],
          };
        } else {
          return {
            'status': false,
            'message': data['message'],
            'drafts': [],
          };
        }
      } else {
        return {
          'status': false,
          'message': 'Failed to load drafts. Server error.',
          'drafts': [],
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Failed to load drafts. Network error: $e',
        'drafts': [],
      };
    }
  }

  //  Get Draft Details
  static Future<Map<String, dynamic>> getDraftDetails(String draftGuid) async {
    final uri = Uri.parse('$baseUrl/get_draft_details/')
        .replace(queryParameters: {'draft_guid': draftGuid});

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status_code'] == 0 &&
            data['data'] != null &&
            data['data'].isNotEmpty) {
          return {
            'status': true,
            'message': data['message'],
            'draft': data['data'][0],
          };
        } else {
          return {
            'status': false,
            'message': data['message'],
            'draft': null,
          };
        }
      } else {
        return {
          'status': false,
          'message': 'Failed to load draft details. Server error.',
          'draft': null,
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Failed to load draft details. Network error: $e',
        'draft': null,
      };
    }
  }

  //  Create Draft
  static Future<Map<String, dynamic>> createDraft(
      Map<String, dynamic> draftData) async {
    final bodyData = draftData.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    final response = await http.post(
      Uri.parse('$baseUrl/post_draft_data/'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: bodyData,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        'status': false,
        'message': 'Failed to create draft',
      };
    }
  }

  //  Update Draft
  static Future<Map<String, dynamic>> updateDraft(
      Map<String, dynamic> draftData) async {
    final bodyData = draftData.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString().trim())}')
        .join('&'); // ✅ Encode & Trim data before sending

    final response = await http.post(
      Uri.parse('$baseUrl/update_draft_details/'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: bodyData,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        'status': false,
        'message': 'Failed to update draft',
      };
    }
  }

  //  Delete Draft
  static Future<Map<String, dynamic>> deleteDraft(String draftGuid) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete_draft_data/'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'draft_guid': draftGuid,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status_code'] == 0) {
        // ✅ Correctly check success status
        return {
          'status': true,
          'message': data['message'],
        };
      } else {
        return {
          'status': false,
          'message': data['message'],
        };
      }
    } else {
      return {
        'status': false,
        'message': 'Failed to delete draft. Server error.',
      };
    }
  }

  // ======================  Reservation Management  ======================

  //  Get Reservation List
  static Future<Map<String, dynamic>> getReservationList(
      String authorGuid) async {
    final uri = Uri.parse('$baseUrl/get_reservation_list/')
        .replace(queryParameters: {'author_guid': authorGuid});
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status_code'] == 0) {
          return {
            'status': true,
            'message': data['message'],
            'reservations': data['data'],
          };
        } else {
          return {
            'status': false,
            'message': data['message'],
            'reservations': [],
          };
        }
      } else {
        return {
          'status': false,
          'message': 'Failed to load reservations. Server error.',
          'reservations': [],
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Failed to load reservations. Network error: $e',
        'reservations': [],
      };
    }
  }

  //  Get Reservation Details
  static Future<Map<String, dynamic>> getReservationDetails(
      String reservationGuid) async {
    final uri = Uri.parse('$baseUrl/get_reservation_details/')
        .replace(queryParameters: {
      'reservation_guid': reservationGuid,
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status_code'] == 0) {
          return {
            'status': true,
            'message': data['message'],
            'reservation': data['data'][0],
          };
        } else {
          return {
            'status': false,
            'message': data['message'],
            'reservation': null,
          };
        }
      } else {
        return {
          'status': false,
          'message': 'Failed to load reservation details. Server error.',
          'reservation': null,
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Failed to load reservation details. Network error: $e',
        'reservation': null,
      };
    }
  }

  //  Create Reservation
  static Future<Map<String, dynamic>> postReservation(
      Map<String, dynamic> reservationData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/post_reservation/'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: reservationData, // ✅ Ensure data is correctly passed
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        'status': false,
        'message': 'Failed to create reservation',
      };
    }
  }

  // ======================  Auto Reservation  ======================
  static Future<Map<String, dynamic>> runAutoReserve(
    String draftGuid,
    int retryMinutes,
  ) async {
    final response =
        await http.post(Uri.parse('$baseUrl/run_reserve/'), headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    }, body: {
      'draft_guid': draftGuid,
      'retry_minutes': retryMinutes.toString(),
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }
}
