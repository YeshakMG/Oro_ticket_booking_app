import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/myticket_controller.dart';

class MyticketView extends GetView<MyticketController> {
  const MyticketView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyticketView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MyticketView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
