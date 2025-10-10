import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyticketController extends GetxController {
  var bookings = <Map<String, dynamic>>[].obs;
  late Box bookingsBox;

  @override
  void onInit() {
    super.onInit();
    _initBoxes();
  }

  Future<void> _initBoxes() async {
    bookingsBox = await Hive.openBox('bookingsBox');
    _loadBookings();
  }

  void _loadBookings() {
    final cachedBookings = bookingsBox.values.toList();
    bookings.value = cachedBookings.cast<Map<String, dynamic>>();
  }

  void refreshBookings() {
    _loadBookings();
  }
}
