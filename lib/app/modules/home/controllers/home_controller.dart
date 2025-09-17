import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeController extends GetxController {
  // User info
  var userName = "".obs;

  // Terminals
  var terminals = <Map<String, dynamic>>[].obs; // [{id, name}]
  var fromLocation = Rxn<Map<String, dynamic>>();
  var toLocation = Rxn<Map<String, dynamic>>();

  // Trips
  var trips = <Map<String, dynamic>>[].obs; // store all trips
  final Dio dio = Dio();

  // Hive boxes
  late Box appBox;
  late Box tripsBox;

  @override
  void onInit() async {
    super.onInit();
    await _initBoxes();
    _loadUser();
    await fetchTerminals();
    await fetchTrips();
  }

  Future<void> _initBoxes() async {
    appBox = Hive.box('appBox');
    tripsBox = await Hive.openBox('tripsBox');
  }

  void _loadUser() {
    final user = appBox.get("user");
    if (user != null && user["name"] != null) {
      userName.value = user["name"];
    }
  }

  /// Fetch terminals from API
  Future<void> fetchTerminals() async {
    try {
      final token = appBox.get("token");
      final baseUrl = dotenv.env['BASE_URL'] ?? "";
      final url = "$baseUrl/terminals";

      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        terminals.value = data.cast<Map<String, dynamic>>();

        // Set default from/to
        if (terminals.isNotEmpty) {
          fromLocation.value = terminals.first;
          if (terminals.length > 1) toLocation.value = terminals[1];
        }
      }
    } catch (e) {
      print("Error fetching terminals: $e");
    }
  }

  /// Fetch trips from API and store locally in Hive
  Future<void> fetchTrips() async {
    try {
      final token = appBox.get("token");
      final baseUrl = dotenv.env['BASE_URL'] ?? "";
      final url = "$baseUrl/trips";

      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        trips.value = data.cast<Map<String, dynamic>>();

        // Save trips locally
        await tripsBox.clear();
        for (var trip in trips) {
          await tripsBox.add(trip);
        }
      }
    } catch (e) {
      print("Error fetching trips: $e");

      // Load trips from local Hive if API fails
      final cachedTrips = tripsBox.values.toList();
      trips.value = cachedTrips.cast<Map<String, dynamic>>();
    }
  }

  /// Getter to filter trips based on selected from/to
  List<Map<String, dynamic>> get filteredTrips {
    if (fromLocation.value == null || toLocation.value == null) return [];
    return trips.where((trip) {
      return trip['departure'] == fromLocation.value!['name'] &&
          trip['destination'] == toLocation.value!['name'];
    }).toList();
  }

  /// Change from location
  void changeFromLocation(Map<String, dynamic> terminal) {
    fromLocation.value = terminal;
  }

  /// Change to location
  void changeToLocation(Map<String, dynamic> terminal) {
    toLocation.value = terminal;
  }

  /// Refresh trips
  Future<void> refreshTrips() async {
    await fetchTrips();
  }
}
