import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/widgets/app_scaffold.dart';
import 'package:oro_ticket_booking_app/core/constants/typography.dart';
import 'package:oro_ticket_booking_app/core/utils/ethiopian_date_converter.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late HomeController controller;
  String greetingMessage = '';

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
    controller.reloadUser();
    greetingMessage = _getGreetingMessage();
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Welcome Back';
    }
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
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select Ethiopian Date",
                      style: AppTextStyles.buttonMediumB.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDropdownField(
                      label: "Year",
                      value: selectedYear,
                      items:
                          List.generate(
                                5,
                                (index) => currentEthiopian.year - 2 + index,
                              )
                              .map(
                                (year) => DropdownMenuItem(
                                  value: year,
                                  child: Text(year.toString()),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        selectedYear = value!;
                        setDialogState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: "Month",
                      value: selectedMonth,
                      items: List.generate(13, (index) => index + 1)
                          .map(
                            (month) => DropdownMenuItem(
                              value: month,
                              child: Text(
                                EthiopianDate(
                                  year: selectedYear,
                                  month: month,
                                  day: 1,
                                ).monthName,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        selectedMonth = value!;
                        setDialogState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: "Day",
                      value: selectedDay,
                      items:
                          List.generate(
                                selectedMonth == 13 ? 6 : 30,
                                (index) => index + 1,
                              )
                              .map(
                                (day) => DropdownMenuItem(
                                  value: day,
                                  child: Text(day.toString()),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        selectedDay = value!;
                        setDialogState(() {});
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(color: Color(0xFF029600)),
                            ),
                            child: Text(
                              "Cancel",
                              style: AppTextStyles.buttonSmall.copyWith(
                                color: const Color(0xFF029600),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              EthiopianDate selectedEthiopian = EthiopianDate(
                                year: selectedYear,
                                month: selectedMonth,
                                day: selectedDay,
                              );
                              controller.selectedDate.value =
                                  EthiopianDateConverter.toGregorian(
                                    selectedEthiopian,
                                  );
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF029600),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              "OK",
                              style: AppTextStyles.buttonSmall.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownField({
    required String label,
    required int value,
    required List<DropdownMenuItem<int>> items,
    required Function(int?) onChanged,
  }) {
    final validValues = items.map((e) => e.value).toList();

    return DropdownButtonFormField<int>(
      initialValue: validValues.contains(value)
          ? value
          : null, // ✅ Safety check
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.caption2.copyWith(
          color: Colors.black87,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF029600), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      style: AppTextStyles.caption2.copyWith(
        color: Colors.grey.shade800,
        fontSize: 13,
      ),
      items: items,
      onChanged: onChanged,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$greetingMessage,",
                        style: AppTextStyles.caption2.copyWith(fontSize: 14),
                      ),
                      Obx(
                        () => Text(
                          controller.userName.value,
                          style: AppTextStyles.heading2.copyWith(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Ready for your next journey?",
                    style: AppTextStyles.caption2.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),

            // Search Card with centered swap button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  // horizontal: 0,
                  vertical: 10,
                ),
                child: Obx(
                  () => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          // Top "From" Field
                          Padding(
                            padding: const EdgeInsets.only(top: 24, bottom: 16),
                            child: _buildEnhancedLocationField(
                              icon: Icons.place_outlined,
                              label: "From",
                              value:
                                  controller.fromLocation.value?['name'] ??
                                  "Select departure",
                              onTap: () => _showLocationPicker(true),
                            ),
                          ),
                          // Bottom "To" Field
                          _buildEnhancedLocationField(
                            icon: Icons.place,
                            label: "To",
                            value:
                                controller.toLocation.value?['name'] ??
                                "Select destination",
                            onTap: () => _showLocationPicker(false),
                          ),
                          SizedBox(height: 16),
                          _buildEnhancedDateField(),
                          // Search Button
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.search, size: 20),
                              label: Text(
                                "Search Bus",
                                style: AppTextStyles.button.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF029600),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                shadowColor: Colors.green.withOpacity(0.4),
                              ),
                              onPressed: () {
                                if (controller.filteredTrips.isNotEmpty) {
                                  Get.toNamed(
                                    '/trip-selection',
                                    arguments: {
                                      "from": controller
                                          .fromLocation
                                          .value?['name'],
                                      "to":
                                          controller.toLocation.value?['name'],
                                      "trips": controller.filteredTrips,
                                      "date": controller.selectedDate.value,
                                    },
                                  );
                                } else {
                                  Get.snackbar(
                                    "No Trips Found",
                                    "No available trips for the selected route",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.redAccent,
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(16),
                                    borderRadius: 12,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      // Centered swap button positioned overlapping between From and To fields
                      Positioned(
                        left: 0,
                        right: 30,
                        top:
                            72, // Approx halfway vertically between the two fields (adjust as needed)
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: controller.swapLocations,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xFF029600),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.7),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.swap_vert,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Popular Destinations
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Popular Destinations",
                        style: AppTextStyles.heading3.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "See All",
                          style: AppTextStyles.caption2.copyWith(
                            color: const Color(0xFF029600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildEnhancedDestinationCard(
                          "Addis Ababa",
                          "Capital City",
                          Icons.location_city,
                        ),
                        const SizedBox(width: 12),
                        _buildEnhancedDestinationCard(
                          "Hawassa",
                          "Lake City",
                          Icons.water_drop,
                        ),
                        const SizedBox(width: 12),
                        _buildEnhancedDestinationCard(
                          "Dire Dawa",
                          "Historical City",
                          Icons.history_edu,
                        ),
                        const SizedBox(width: 12),
                        _buildEnhancedDestinationCard(
                          "Jimma",
                          "Coffee Origin",
                          Icons.local_cafe,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Available Transport Types
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Available Transport",
                    style: AppTextStyles.heading3.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildEnhancedTransportType(
                        "Bus",
                        Icons.directions_bus,
                        const Color(0xFF029600),
                      ),
                      _buildEnhancedTransportType(
                        "MiniBus",
                        Icons.airport_shuttle,
                        Colors.blue,
                      ),
                      _buildEnhancedTransportType(
                        "Taxi",
                        Icons.local_taxi,
                        Colors.orange,
                      ),
                      _buildEnhancedTransportType(
                        "More",
                        Icons.more_horiz,
                        Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularSwapButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: Icon(icon, size: 20, color: Colors.green),
        ),
      ),
    );
  }

  Widget _buildEnhancedLocationField({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    bool isFrom = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF029600).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF029600), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption2.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: value.contains("Select")
                        ? AppTextStyles.body2.copyWith(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          )
                        : AppTextStyles.body1.copyWith(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedDateField() {
    return GestureDetector(
      onTap: () => _showEthiopianDatePicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF029600).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Color(0xFF029600),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Travel Date",
                    style: AppTextStyles.caption2.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      controller.selectedDate.value != null
                          ? EthiopianDateConverter.format(
                              EthiopianDateConverter.toEthiopian(
                                controller.selectedDate.value!,
                              ),
                            )
                          : "Select travel date",
                      style: controller.selectedDate.value != null
                          ? AppTextStyles.body1.copyWith(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )
                          : AppTextStyles.body2.copyWith(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedDestinationCard(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {}, // Handle tap
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF029600).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF029600), size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey.shade400, size: 14),
                const SizedBox(width: 4),
                Text(
                  "2h 30m",
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedTransportType(String type, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {}, // Handle tap
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            type,
            style: AppTextStyles.caption.copyWith(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationPicker(bool isFrom) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Text(
                isFrom ? "Select Departure" : "Select Destination",
                style: AppTextStyles.buttonMediumB.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.terminals.length,
                  itemBuilder: (context, index) {
                    final terminal = controller.terminals[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF029600).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.place,
                            color: Color(0xFF029600),
                          ),
                        ),
                        title: Text(
                          terminal['name'],
                          style: AppTextStyles.subtitle3.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          if (isFrom) {
                            controller.changeFromLocation(terminal);
                          } else {
                            controller.changeToLocation(terminal);
                          }
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
