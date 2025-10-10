import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/widgets/app_scaffold.dart';
import 'package:oro_ticket_booking_app/core/constants/typography.dart';
import 'package:oro_ticket_booking_app/core/utils/ethiopian_date_converter.dart';
import '../../book/views/book_view.dart';
import '../controllers/home_controller.dart';


class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
    controller.reloadUser();
  }

  void _showEthiopianDatePicker(BuildContext context) {
    EthiopianDate currentEthiopian = controller.selectedDate.value != null
        ? EthiopianDateConverter.toEthiopian(controller.selectedDate.value!)
        : EthiopianDateConverter.now();

    int selectedYear = currentEthiopian.year;
    int selectedMonth = currentEthiopian.month;
    int selectedDay = currentEthiopian.day;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Ethiopian Date"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Year
              DropdownButtonFormField<int>(
                value: selectedYear,
                decoration: const InputDecoration(labelText: "Year"),
                items: List.generate(5, (index) => currentEthiopian.year - 2 + index)
                    .map((year) => DropdownMenuItem(value: year, child: Text(year.toString())))
                    .toList(),
                onChanged: (value) => selectedYear = value!,
              ),
              // Month
              DropdownButtonFormField<int>(
                value: selectedMonth,
                decoration: const InputDecoration(labelText: "Month"),
                items: List.generate(13, (index) => index + 1)
                    .map((month) => DropdownMenuItem(value: month, child: Text(EthiopianDate(year: selectedYear, month: month, day: 1).monthName)))
                    .toList(),
                onChanged: (value) => selectedMonth = value!,
              ),
              // Day
              DropdownButtonFormField<int>(
                value: selectedDay,
                decoration: const InputDecoration(labelText: "Day"),
                items: List.generate(selectedMonth == 13 ? 6 : 30, (index) => index + 1)
                    .map((day) => DropdownMenuItem(value: day, child: Text(day.toString())))
                    .toList(),
                onChanged: (value) => selectedDay = value!,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                EthiopianDate selectedEthiopian = EthiopianDate(year: selectedYear, month: selectedMonth, day: selectedDay);
                controller.selectedDate.value = EthiopianDateConverter.toGregorian(selectedEthiopian);
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Oromia Transport Agency",
      currentBottomNavIndex: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white), 
          onPressed: () {},
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            const Text("Hello,", style: AppTextStyles.caption2),
            Obx(() => Text(controller.userName.value, style: AppTextStyles.heading3)),
            const SizedBox(height: 16),

            // Dropdown: From
            Obx(() => DropdownButtonFormField<Map<String, dynamic>>(
                  value: controller.fromLocation.value,
                  decoration: InputDecoration(
                    hintText: "From",
                    hintStyle: AppTextStyles.button,
                    prefixIcon: const Icon(Icons.place_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: controller.terminals
                      .map((terminal) => DropdownMenuItem<Map<String, dynamic>>(
                            value: terminal,
                            child: Text(terminal['name']),
                          ))
                      .toList(),
                  onChanged: (value) => controller.changeFromLocation(value!),
                )),
            const SizedBox(height: 12),

            // Dropdown: To
            Obx(() => DropdownButtonFormField<Map<String, dynamic>>(
                  value: controller.toLocation.value,
                  decoration: InputDecoration(
                    hintText: "Where are you going today?",
                    hintStyle: AppTextStyles.button,
                    prefixIcon: const Icon(Icons.place),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.swap_vert, color: Colors.green),
                      onPressed: controller.swapLocations,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: controller.terminals
                      .map((terminal) => DropdownMenuItem<Map<String, dynamic>>(
                            value: terminal,
                            child: Text(terminal['name']),
                          ))
                      .toList(),
                  onChanged: (value) => controller.changeToLocation(value!),
                )),
            const SizedBox(height: 12),

            // Date Picker
            Obx(() => TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Select Date",
                    hintStyle: AppTextStyles.button,
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  controller: TextEditingController(
                    text: controller.selectedDate.value != null
                        ? EthiopianDateConverter.format(EthiopianDateConverter.toEthiopian(controller.selectedDate.value!))
                        : "",
                  ),
                  onTap: () => _showEthiopianDatePicker(context),
                )),
            const SizedBox(height: 12),

            // Search Button for trip
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (controller.filteredTrips.isNotEmpty) {
                    Get.toNamed('/trip-selection', arguments: {
                      "from": controller.fromLocation.value?['name'],
                      "to": controller.toLocation.value?['name'],
                      "trips": controller.filteredTrips,
                      "date": controller.selectedDate.value,
                    });
                  } else {
                    Get.snackbar(
                      "No Trips Found",
                      "No available trips for the selected route",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text("Search Bus", style: AppTextStyles.button),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ✅ Reusable quick-buy card
class _QuickBuyCard extends StatelessWidget {
  final String title;
  const _QuickBuyCard(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          "Buy ticket to\n$title",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

