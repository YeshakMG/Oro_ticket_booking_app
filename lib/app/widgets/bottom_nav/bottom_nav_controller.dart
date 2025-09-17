import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/modules/home/views/home_view.dart';
import 'package:oro_ticket_booking_app/app/modules/myticket/views/myticket_view.dart';
import 'package:oro_ticket_booking_app/app/modules/settings/views/settings_view.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}

