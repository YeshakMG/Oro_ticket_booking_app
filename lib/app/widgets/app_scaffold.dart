import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/modules/home/views/home_view.dart';
import 'package:oro_ticket_booking_app/app/modules/myticket/views/myticket_view.dart';
import 'package:oro_ticket_booking_app/app/routes/app_pages.dart';
import 'package:oro_ticket_booking_app/core/constants/colors.dart';
import 'package:oro_ticket_booking_app/core/constants/typography.dart';

class AppScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBottomNavBar;
  final int currentBottomNavIndex;
  final Function(int)? onBottomNavTap;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.showBottomNavBar = true,
    this.currentBottomNavIndex = 0,
    this.onBottomNavTap,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xFF029600)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: AppTextStyles.button.copyWith(color: Colors.white),
        ),
        backgroundColor: Color(0xFF029600),
        centerTitle: true,
        actions: widget.actions,
      ),
      body: SafeArea(child: widget.body),
      bottomNavigationBar: widget.showBottomNavBar
          ? BottomNavigationBar(
              currentIndex: widget.currentBottomNavIndex,
              onTap:
                  widget.onBottomNavTap ??
                  (index) {
                    switch (index) {
                      case 0:
                        Get.offAllNamed(Routes.HOME);
                        break;
                      case 1:
                        Get.offAllNamed(Routes.MYTICKET);
                        break;
                      case 2:
                        Get.offAllNamed(Routes.SETTINGS);
                        break;
                    }
                  },
              selectedItemColor: Color(0xFF029600),
              unselectedItemColor: Colors.grey,
              backgroundColor: AppColors.card,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.confirmation_number_outlined),
                  activeIcon: Icon(Icons.confirmation_number),
                  label: 'My Ticket',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            )
          : null,
    );
  }
}
