import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/modules/login/controllers/login_controller.dart';
import 'package:oro_ticket_booking_app/app/modules/auth/auth_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
