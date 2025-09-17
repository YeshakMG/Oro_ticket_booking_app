import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/widgets/app_scaffold.dart';

import '../controllers/myticket_controller.dart';

class MyticketView extends GetView<MyticketController> {
  const MyticketView({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "My Ticket",
      currentBottomNavIndex: 1,
     

      body: const Center(
        child: Text('MyticketView is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
