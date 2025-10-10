import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../controllers/profile_edit_controller.dart';
import 'package:oro_ticket_booking_app/app/modules/auth/auth_service.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
    Get.lazyPut<ProfileEditController>(
      () => ProfileEditController(),
    );
  }
}
