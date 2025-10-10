import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../auth_service.dart';
import 'package:oro_ticket_booking_app/app/modules/settings/controllers/settings_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<AuthController>(() => AuthController());
    // Make SettingsController available app-wide (e.g., for language on login)
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
  }
}
