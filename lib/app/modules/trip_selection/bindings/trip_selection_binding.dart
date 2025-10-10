import 'package:get/get.dart';
import '../controllers/trip_selection_controller.dart';

class TripSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripSelectionController>(() => TripSelectionController());
  }
}