import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/modules/signup/controllers/signup_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}
