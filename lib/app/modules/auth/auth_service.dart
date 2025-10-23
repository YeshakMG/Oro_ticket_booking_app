import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";

  // -------------------------
  // Endpoints
  // -------------------------
  static const String _signupPath = "/customers";
  static const String _loginPath = "/customer-auth/login";
  static const String _resetPasswordPath = "/auth/reset-password";
  static const String _changePasswordPath = "/auth/change-password";
  static const String _verifyTokenPath = "/auth/verify-token";
  static const String _profilePath = "/auth/profile";
  static const String _deleteAccountPath = "/auth/delete-account";
  static const String _terminalsPath = "/terminals";
  static const String _complaintReasonsPath = "/complaint-reasons";
  static const String _submitComplaintPath = "/complaint";

  Uri _buildUri(String path) => Uri.parse("$baseUrl$path");

  /// Sign Up
  Future<Map<String, dynamic>> signup({
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required int roleId,
  }) async {
    final url = _buildUri(_signupPath);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fullName": fullName,
        "phone": phone,
        "email": email,
        "password": password,
        "role_id": roleId,
        
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Check if signup was actually successful
      if (data['status'] == 'error') {
        throw Exception(data['message'] ?? 'Signup failed');
      }
      return data;
    } else {
      throw Exception(data["message"] ?? "Signup failed");
    }
  }

  /// Login
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final url = _buildUri(_loginPath);
    if (kDebugMode) {
      debugPrint('➡️  POST $url');
      debugPrint('📨 Payload: {"phone": "$phone", "password": "[REDACTED]"}');
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "phone": phone,
        "password": password,

      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('✅ Login 200 OK');
        debugPrint('🧾 Response data: $data');
      }
      // Check if login was actually successful by presence of token in nested data
      if (data['status'] == 'success' && data['data'] != null && data['data'].containsKey('token')) {
        // Return consistent format with token and customer
        return {
          'token': data['data']['token'],
          'customer': data['data']['customer'],
        };
      } else {
        // API returned 200 but no token, treat as failure
        final message = data['message'] ?? 'Invalid credentials';
        if (kDebugMode) {
          debugPrint('❌ Login failed: $message');
        }
        throw Exception(message);
      }
    } else {
      if (kDebugMode) {
        debugPrint('❌ Login error ${response.statusCode}');
        debugPrint('🧾 Response body: ${response.body}');
      }
      throw Exception(data["message"] ?? "Login failed (${response.statusCode})");
    }
  }
  Future<void> logout() async {
    
    // Implement logout logic if needed, e.g., invalidate token on server
    return;
  }

  Future <void> resetPassword(String email) async {
    final url = _buildUri(_resetPasswordPath);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data["message"] ?? "Password reset failed");
    }
  }
  Future<void> changePassword(String token, String newPassword) async {
    final url = _buildUri(_changePasswordPath);
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({"newPassword": newPassword}),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data["message"] ?? "Change password failed");
    }
  }
  Future <bool> verifyToken(String token) async {
    final url = _buildUri(_verifyTokenPath);
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
        
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  Future<Map<String, dynamic>> fetchUserProfile(String token) async {
    final url = _buildUri(_profilePath);
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Fetch profile failed");
    }
  }
  Future<Map<String, dynamic>> updateUserProfile(String token, Map<String, dynamic> updates) async {
    final url = _buildUri(_profilePath);
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"

      },
      body: jsonEncode(updates),
      

    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Update profile failed");
    }
  }
  Future<void> deleteUserAccount(String token) async {
    final url = _buildUri(_deleteAccountPath);
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data["message"] ?? "Delete account failed");
    }
  }

  Future<void> allterminals () async {
    final url = _buildUri(_terminalsPath);
    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data["message"] ?? "Fetching terminals failed");
    }
  }

  /// Fetch terminals with authentication
  Future<List<Map<String, dynamic>>> fetchTerminals(String token) async {
    final url = _buildUri(_terminalsPath);
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    debugPrint("fetchTerminals: Response status: ${response.statusCode}");
    debugPrint("fetchTerminals: Response body: ${response.body}");

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final responseData = data;
      final dataList = responseData is Map ? responseData['data'] as List : responseData as List;
      return List<Map<String, dynamic>>.from(dataList);
    } else {
      throw Exception(data["message"] ?? "Fetching terminals failed");
    }
  }

  /// Fetch complaint categories
  Future<List<Map<String, dynamic>>> fetchComplaintCategories() async {
    final url = _buildUri(_complaintReasonsPath);
    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception(data["message"] ?? "Fetching complaint categories failed");
    }
  }

  /// Submit feedback
  Future<Map<String, dynamic>> submitFeedback({
    required String category,
    required String message,
    required String userToken,
  }) async {
    final url = _buildUri(_submitComplaintPath);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
      body: jsonEncode({
        "category": category,
        "message": message,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Feedback submission failed");
    }
  }


}
