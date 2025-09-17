import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";

  /// Sign Up
  Future<Map<String, dynamic>> signup({
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required int roleId,
  }) async {
    final url = Uri.parse("$baseUrl/customers");
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
    final url = Uri.parse("$baseUrl/auth/login");
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
      return data;
    } else {
      throw Exception(data["message"] ?? "Login failed");
    }
  }
  Future<void> logout() async {
    
    // Implement logout logic if needed, e.g., invalidate token on server
    return;
  }

  Future <void> resetPassword(String email) async {
    final url = Uri.parse("$baseUrl/auth/reset-password");
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
    final url = Uri.parse("$baseUrl/auth/change-password");
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
    final url = Uri.parse("$baseUrl/auth/verify-token");
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
    final url = Uri.parse("$baseUrl/auth/profile");
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
    final url = Uri.parse("$baseUrl/auth/profile");
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
    final url = Uri.parse("$baseUrl/auth/delete-account");
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
    final url = Uri.parse("$baseUrl/terminals");
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


}
