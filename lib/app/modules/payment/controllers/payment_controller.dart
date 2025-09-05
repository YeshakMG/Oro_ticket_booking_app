import 'package:get/get.dart';

class PaymentController extends GetxController {
var selectedSeats = <String>[].obs;

  void setSeats(List<String> seats) {
    selectedSeats.value = seats;
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      setSeats(List<String>.from(Get.arguments));
    }
  }
}
