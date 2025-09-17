import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/widgets/app_scaffold.dart';
import 'package:oro_ticket_booking_app/app/widgets/bottom_nav/bottom_nav_widgets.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Settings",
      currentBottomNavIndex: 2,
      body: const Center(
        child: Text('SettingsView is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
