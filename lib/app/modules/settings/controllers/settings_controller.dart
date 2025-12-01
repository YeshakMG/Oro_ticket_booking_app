import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:oro_ticket_booking_app/app/modules/auth/auth_service.dart';

class SettingsController extends GetxController {
  final box = Hive.box('appBox');
  final AuthService _authService = Get.find<AuthService>();

  RxString userName = "".obs;
  RxString userPhone = "".obs;
  RxBool rememberMe = false.obs;

  // Language preference (store and work with language codes)
  RxString selectedLanguageCode = "en".obs;
  final RxList<Map<String, String>> languages = <Map<String, String>>[].obs; // [{code,name,nativeName}]

  // Complaint / Feedback
  RxString feedback = "".obs;
  RxString selectedCategory = "".obs;
  final RxList<Map<String, dynamic>> complaintCategories = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadLanguages();
    loadSettings();
    fetchComplaintCategories();
  }

  void loadSettings() {
    final user = box.get("user", defaultValue: {});
    if (user is Map) {
      userName.value = user["full_name"] ?? "Guest User";
      userPhone.value = user["phone"] ?? "";
    }
    rememberMe.value = box.get("rememberPhone") != null;

    // Load saved language (prefer code)
    final saved = box.get("language");
    if (saved is String && saved.isNotEmpty) {
      // If previously saved a code, keep it; else try map name->code
      final byCode = languages.firstWhereOrNull((e) => e['code'] == saved);
      if (byCode != null) {
        selectedLanguageCode.value = byCode['code']!;
      } else {
        final byName = languages.firstWhereOrNull((e) => e['name'] == saved);
        selectedLanguageCode.value = byName != null ? byName['code']! : 'en';
      }
    } else {
      selectedLanguageCode.value = 'en';
    }
  }

  void toggleRememberMe(bool value) async {
    rememberMe.value = value;
    if (!value) {
      await box.delete("rememberPhone");
      // Note: Password storage removed for security
    }
  }

  void changeLanguage(String code) async {
    selectedLanguageCode.value = code;
    await box.put("language", code);
    Get.updateLocale(Locale(code));
  }

  Future<void> submitFeedback() async {
    if (selectedCategory.value.isEmpty) {
      Get.snackbar("Error", "Please select a complaint category");
      return;
    }
    if (feedback.value.isEmpty) {
      Get.snackbar("Error", "Please enter your complaint/feedback");
      return;
    }

    try {
      final token = box.get("token");
      if (token == null) {
        Get.snackbar("Error", "Authentication required. Please login again.");
        return;
      }

      await _authService.submitFeedback(
        token: token,
        category: selectedCategory.value,
        message: feedback.value,
        userToken: token,
      );

      Get.snackbar("Thank you", "Your feedback has been submitted");
      selectedCategory.value = "";
      feedback.value = "";
    } catch (e) {
      Get.snackbar("Error", "Failed to submit feedback: $e");
    }
  }

  Future<void> logout() async {
    final getStorage = GetStorage();
    await box.delete("token");
    await box.delete("user");
    await box.delete("rememberPhone");
    // Note: Password storage removed for security
    await getStorage.remove("fullName");
    await getStorage.remove("phone");
    await getStorage.remove("email");
    Get.offAllNamed("/login"); // navigate back to login
  }

  Future<void> _loadLanguages() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/i18n/languages.json');
      final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
      final list = (parsed['languages'] as List)
          .map((e) => {
                'code': (e as Map<String, dynamic>)['code'] as String,
                'name': (e)['name'] as String,
                'nativeName': (e)['nativeName'] as String,
              })
          .toList();
      if (list.isNotEmpty) {
        languages.assignAll(list);
        final defaultCode = (parsed['default'] as String?) ?? list.first['code']!;
        if (!languages.any((e) => e['code'] == selectedLanguageCode.value)) {
          selectedLanguageCode.value = defaultCode;
        }
      } else {
        languages.assignAll([
          {'code': 'en', 'name': 'English', 'nativeName': 'English'},
          {'code': 'am', 'name': 'Amharic', 'nativeName': 'አማርኛ'},
          {'code': 'om', 'name': 'Afaan Oromo', 'nativeName': 'Afaan Oromo'},
        ]);
      }
    } catch (_) {
      languages.assignAll([
        {'code': 'en', 'name': 'English', 'nativeName': 'English'},
        {'code': 'am', 'name': 'Amharic', 'nativeName': 'አማርኛ'},
        {'code': 'om', 'name': 'Afaan Oromo', 'nativeName': 'Afaan Oromo'},
      ]);
      if (!languages.any((e) => e['code'] == selectedLanguageCode.value)) {
        selectedLanguageCode.value = 'en';
      }
    }
  }

  Future<void> fetchComplaintCategories() async {
    try {
      final token = box.get("token");
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token is missing or invalid');
      }
      final categories = await _authService.fetchComplaintCategories(token);
      complaintCategories.assignAll(categories);
    } catch (e) {
      debugPrint("Error fetching complaint categories: $e");
      // Fallback categories
      complaintCategories.assignAll([
        {'id': '1', 'name': 'Technical Issue'},
        {'id': '5', 'name': 'Other'},
      ]);
    }
  }
}
