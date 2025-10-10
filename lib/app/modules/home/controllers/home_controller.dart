import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oro_ticket_booking_app/core/utils/ethiopian_date_converter.dart';
import 'package:oro_ticket_booking_app/app/modules/auth/auth_service.dart';
import 'package:oro_ticket_booking_app/app/data/models/user_model.dart';

class HomeController extends GetxController {
  // User info
  var userName = "".obs;

  // Terminals
  var terminals = <Map<String, dynamic>>[].obs; // [{id, name}]
  var fromLocation = Rxn<Map<String, dynamic>>();
  var toLocation = Rxn<Map<String, dynamic>>();

  // Date
  var selectedDate = Rxn<DateTime>();

  // Trips
  var trips = <Map<String, dynamic>>[].obs; // store all trips

  // Hive boxes
  late Box appBox;
  late Box tripsBox;

  @override
  void onInit() {
    super.onInit();
    _initBoxes(); // ✅ no async directly in onInit
  }

  Future<void> _initBoxes() async {
    appBox = Hive.box('appBox');
    tripsBox = await Hive.openBox('tripsBox');
    _loadUser();
    selectedDate.value = EthiopianDateConverter.toGregorian(EthiopianDateConverter.now());
    await fetchTerminals();
    await fetchTrips();
  }

  /// Loads the user data from GetStorage and updates the userName observable.
  /// Handles cases where data is null, invalid, or malformed.
  void _loadUser() {
    try {
      final box = GetStorage();
      final fullName = box.read("fullName");
      debugPrint("_loadUser: Full name from GetStorage: $fullName");
      if (fullName != null) {
        userName.value = fullName;
        debugPrint("_loadUser: User name set to: ${userName.value}");
      } else {
        // Handle invalid or missing data gracefully
        userName.value = "Unknown User";
        debugPrint("_loadUser: User data invalid or missing, set to: ${userName.value}");
      }
    } catch (e) {
      // Log error for debugging; in production, use a proper logging library
      debugPrint("Error loading user: $e");
      userName.value = "Error Loading User";
    }
  }

  /// Public method to reload user data
  void reloadUser() {
    _loadUser();
  }


  /// Fetch terminals from API
  Future<void> fetchTerminals() async {
    debugPrint("fetchTerminals: Starting to fetch terminals");
    try {
      // Retrieve and validate token
      final token = appBox.get("token");
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token is missing or invalid');
      }
      debugPrint("fetchTerminals: Token retrieved: present");

      final terminalsList = await AuthService().fetchTerminals(token);
      terminals.value = terminalsList.cast<Map<String, dynamic>>();
      debugPrint("fetchTerminals: Terminals loaded: ${terminals.length} items");
      debugPrint("fetchTerminals: Terminals list: $terminals");
    } catch (e) {
      debugPrint("Error fetching terminals from API: $e");
      debugPrint("fetchTerminals: Using dummy terminal data");
      // Use dummy terminal data as fallback
      terminals.value = [
        {'id': 1, 'name': 'Addis Ababa Terminal'},
        {'id': 2, 'name': 'Dire Dawa Terminal'},
        {'id': 3, 'name': 'Hawassa Terminal'},
        {'id': 4, 'name': 'Bahir Dar Terminal'},
        {'id': 5, 'name': 'Mekelle Terminal'},
        {'id': 6, 'name': 'Gondar Terminal'},
        {'id': 7, 'name': 'Jimma Terminal'},
        {'id': 8, 'name': 'Dessie Terminal'},
      ];
    }

    // Set default from/to
    if (terminals.isNotEmpty) {
      fromLocation.value = terminals.first;
      debugPrint("fetchTerminals: Set fromLocation to: ${fromLocation.value}");
      if (terminals.length > 1) {
        toLocation.value = terminals[1];
        debugPrint("fetchTerminals: Set toLocation to: ${toLocation.value}");
      }
    } else {
      debugPrint("fetchTerminals: No terminals available");
    }
    debugPrint("fetchTerminals: Completed");
  }

  /// Fetch trips from API and store locally in Hive
  Future<void> fetchTrips() async {
    // Use dummy data since API endpoint is not available
    final dummyTrips = <Map<String, dynamic>>[
      {
        'plateNumber': 'ABC-123',
        'level': 'VIP',
        'departure': terminals.isNotEmpty ? terminals[0]['name'] : 'Terminal 1',
        'destination': terminals.length > 1 ? terminals[1]['name'] : 'Terminal 2',
        'seatsAvailable': 20,
        'price': 150.0,
      },
      {
        'plateNumber': 'DEF-456',
        'level': 'Standard',
        'departure': terminals.length > 1 ? terminals[1]['name'] : 'Terminal 2',
        'destination': terminals.isNotEmpty ? terminals[0]['name'] : 'Terminal 1',
        'seatsAvailable': 30,
        'price': 100.0,
      },
    ];

    trips.value = dummyTrips;

    // Save trips locally
    await tripsBox.clear();
    for (var trip in trips) {
      await tripsBox.add(trip);
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

  /// Swap from and to locations
  void swapLocations() {
    final temp = fromLocation.value;
    fromLocation.value = toLocation.value;
    toLocation.value = temp;
  }

  /// Refresh trips
  Future<void> refreshTrips() async {
    await fetchTrips();
  }
}
