import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/modules/home/views/home_view.dart';
import 'package:oro_ticket_booking_app/app/modules/myticket/views/myticket_view.dart';
import 'package:oro_ticket_booking_app/app/routes/app_pages.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oro_ticket_booking_app/core/constants/colors.dart';
import 'package:oro_ticket_booking_app/core/constants/typography.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';

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
    final activeIcons = [
      Icon(Iconsax.home, color: AppColors.primary),
      Icon(Iconsax.ticket, color: AppColors.primary),
      Icon(Iconsax.setting_2, color: AppColors.primary),
    ];
    final inactiveIcons = [
      Icon(Iconsax.home, color: Colors.grey.shade400),
      Icon(Iconsax.ticket, color: Colors.grey.shade400),
      Icon(Iconsax.setting_2, color: Colors.grey.shade400),
    ];
    final labels = ["Home", "My Ticket", "Settings"];
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
          ? CircleNavBar(
              activeIcons: activeIcons,
              inactiveIcons: inactiveIcons,
              levels: labels,
              color: AppColors.primary,
              circleColor: AppColors.primary.withValues(alpha: 0.1),
              height: 60,
              circleWidth: 50,
              activeIndex: widget.currentBottomNavIndex,
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
              activeLevelsStyle: AppTextStyles.caption.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),

              inactiveLevelsStyle: AppTextStyles.caption.copyWith(
                color: Colors.grey.shade400,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              cornerRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              // padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              shadowColor: Colors.black.withValues(alpha: 0.5),
              elevation: 10,

              tabCurve: Curves.easeIn,
            )
          : null,
    );
  }
}
