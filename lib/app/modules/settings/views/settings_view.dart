import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oro_ticket_booking_app/app/widgets/app_scaffold.dart';
import 'package:oro_ticket_booking_app/core/constants/colors.dart';
import 'package:oro_ticket_booking_app/core/constants/typography.dart';

import '../controllers/settings_controller.dart';
import 'profile_edit_view.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Settings",
      currentBottomNavIndex: 2,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar on top
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green,
                      child: Text(
                        controller.userName.value.isNotEmpty
                            ? controller.userName.value[0].toUpperCase()
                            : "?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Name and phone below
                    Column(
                      children: [
                        Text(
                          controller.userName.value,
                          style: AppTextStyles.heading3,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          controller.userPhone.value,
                          style: AppTextStyles.caption2.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Edit button
                    OutlinedButton.icon(
                      onPressed: () {
                        Get.to(() => const ProfileEditView());
                      },
                      icon: const Icon(
                        Iconsax.edit,
                        size: 16,
                        color: Colors.green,
                      ),
                      label: const Text("Edit Profile"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Preferences Section
            _buildCollapsibleSection(
              index: 0,
              title: "Preferences",
              icon: Iconsax.language_circle,
              children: [
                // // Remember Me
                // Obx(() => SwitchListTile(
                //       title: Text("Remember Me", style: AppTextStyles.body1),
                //       subtitle: const Text("Stay logged in on this device"),
                //       value: controller.rememberMe.value,
                //       onChanged: controller.toggleRememberMe,
                //       activeColor: Colors.green,
                //     )),
                // const Divider(),

                // Language Preference
                Text(
                  "Language",
                  style: AppTextStyles.subtitle2.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final items = controller.languages;
                  final selected = controller.selectedLanguageCode.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selected,
                      isExpanded: true,
                      underline: const SizedBox(),
                      onChanged: (value) {
                        if (value != null) controller.changeLanguage(value);
                      },
                      items: items
                          .map(
                            (lang) => DropdownMenuItem(
                              value: lang['code'],
                              child: Text(
                                '${lang['code']!.toUpperCase()} — ${lang['nativeName']}',
                                style: AppTextStyles.subtitle2.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),

            // Support Section
            _buildCollapsibleSection(
              index: 1,
              title: "Support & Feedback",
              icon: Iconsax.support,
              children: [
                // Complaint Category
                Text(
                  "Category",
                  style: AppTextStyles.subtitle2.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final categories = controller.complaintCategories;
                  final selected = controller.selectedCategory.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selected.isEmpty ? null : selected,
                      isExpanded: true,
                      hint: Text(
                        "Select a category",
                        style: AppTextStyles.subtitle2.copyWith(fontSize: 10),
                      ),
                      underline: const SizedBox(),
                      onChanged: (value) {
                        if (value != null)
                          controller.selectedCategory.value = value;
                      },
                      items: categories
                          .map(
                            (category) => DropdownMenuItem<String>(
                              value: category['name'] as String,
                              child: Text(
                                category['name'] as String,
                                style: AppTextStyles.subtitle2.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Complaint & Feedback
                Text(
                  "Message",
                  style: AppTextStyles.subtitle2.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => TextFormField(
                    initialValue: controller.feedback.value,
                    onChanged: (val) => controller.feedback.value = val,
                    decoration: InputDecoration(
                      hintText: "Write your complaint or feedback here...",
                      hintStyle: AppTextStyles.subtitle2.copyWith(
                        color: Colors.grey.shade400,
                        fontSize: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    maxLines: 4,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Submit Feedback",
                      style: AppTextStyles.button,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Policies Section
            _buildCollapsibleSection(
              index: 2,
              title: "Policies & Legal",
              icon: Iconsax.shield,
              children: [
                _buildPolicyItem(
                  // icon: Icons.description,
                  title: "Terms of Service",
                  onTap: () => _showPolicyDialog(
                    "Terms of Service",
                    _getTermsOfService(),
                  ),
                ),
                // const Divider(),
                _buildPolicyItem(
                  // icon: Icons.privacy_tip,
                  title: "Privacy Policy",
                  onTap: () =>
                      _showPolicyDialog("Privacy Policy", _getPrivacyPolicy()),
                ),
                // const Divider(),
                _buildPolicyItem(
                  // icon: Icons.help,
                  title: "Help & Support",
                  onTap: () =>
                      _showPolicyDialog("Help & Support", _getHelpAndSupport()),
                ),
                // const Divider(),
                _buildPolicyItem(
                  // icon: Icons.info,
                  title: "About",
                  onTap: () => _showPolicyDialog("About", _getAbout()),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                SizedBox(width: 20),
                GestureDetector(
                  onTap: controller.logout,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Iconsax.logout_1, color: AppColors.error),
                      SizedBox(width: 10),
                      Text(
                        "Logout",
                        style: AppTextStyles.subtitle2.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyItem({
    // required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      // leading: Icon(icon, color: Colors.green),
      title: Text(title, style: AppTextStyles.subtitle2.copyWith(fontSize: 10)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildCollapsibleSection({
    required int index,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Obx(() {
      final isExpanded = controller.expandedTileIndex.value == index;

      return Theme(
        data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: (_) => controller.toggleTile(index),
          leading: Icon(icon, color: Colors.green),
          title: Text(
            title,
            style: AppTextStyles.subtitle2.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showPolicyDialog(String title, String content) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 1000),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: Scrollbar(
                    radius: const Radius.circular(8),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        content,
                        style: AppTextStyles.body1.copyWith(
                          fontSize: 10,
                          height: 1.5,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text("Close", style: AppTextStyles.button),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTermsOfService() {
    return """
Terms of Service for Oromia Transport Agency Bus Booking App

Last Updated: ${DateTime.now().year}

1. Acceptance of Terms
By accessing and using the Oromia Transport Agency bus booking application ("App"), you accept and agree to be bound by the terms and provision of this agreement.

2. Use License
Permission is granted to temporarily use the App for personal, non-commercial transitory viewing only.

3. Booking and Payment
- All bookings are subject to availability
- Payment must be completed at the time of booking
- Refunds are processed according to our refund policy
- Cancellations must be made at least 2 hours before departure

4. User Responsibilities
- Provide accurate booking information
- Arrive at the station 30 minutes before departure
- Present valid ID and booking confirmation
- Comply with all transportation regulations

5. Limitation of Liability
Oromia Transport Agency shall not be liable for any indirect, incidental, special, consequential or punitive damages.

6. Contact Information
For questions about these Terms, please contact us at support@oromia-transport.et
""";
  }

  String _getPrivacyPolicy() {
    return """
Privacy Policy for Oromia Transport Agency Bus Booking App

Last Updated: ${DateTime.now().year}

1. Information We Collect
- Personal information (name, phone, email) for booking purposes
- Payment information processed securely through our payment partners
- Location data for station selection and route optimization
- Device information for app performance and security

2. How We Use Your Information
- Process and confirm bus bookings
- Communicate booking details and updates
- Improve our services and app performance
- Ensure security and prevent fraud
- Comply with legal obligations

3. Information Sharing
We do not sell, trade, or otherwise transfer your personal information to third parties, except:
- To process payments through secure payment processors
- When required by law or to protect our rights
- With your explicit consent

4. Data Security
We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.

5. Your Rights
You have the right to:
- Access your personal information
- Correct inaccurate information
- Request deletion of your data
- Opt out of marketing communications

6. Contact Us
For privacy-related questions, email: privacy@oromia-transport.et
""";
  }

  String _getHelpAndSupport() {
    return """
Help & Support - Oromia Transport Agency

Need assistance with your bus booking? We're here to help!

Booking Help:
• How to search and book tickets
• Payment methods and security
• Seat selection and preferences
• Booking modifications and cancellations

Travel Information:
• Station locations and facilities
• Luggage policies and restrictions
• Check-in procedures and requirements
• Boarding passes and QR codes

Technical Support:
• App download and installation
• Login and account issues
• Payment processing problems
• App crashes and technical issues

Contact Us:
📞 Customer Service: +251-XXX-XXXX
📧 Email: support@oromia-transport.et
🌐 Website: www.oromia-transport.et

Emergency Contacts:
For travel emergencies or urgent situations, please contact our 24/7 emergency hotline.

Operating Hours:
Monday - Saturday: 6:00 AM - 10:00 PM
Sunday: 8:00 AM - 6:00 PM
""";
  }

  String _getAbout() {
    return """
About Oromia Transport Agency

Oromia Transport Agency (OTA) is the leading public transportation provider in the Oromia region, committed to providing safe, reliable, and affordable bus transportation services.

Our Mission:
To provide efficient, safe, and accessible transportation solutions that connect communities and support economic development across the Oromia region.

Our Vision:
To be the most trusted and preferred transportation provider in Ethiopia, setting the standard for excellence in public transportation.

Services:
• Inter-city bus routes connecting major cities and towns
• Express and regular service options
• Online booking and mobile payment integration
• Real-time schedule updates and tracking
• Customer support and feedback systems

App Version: 1.0.0
© ${DateTime.now().year} Oromia Transport Agency. All rights reserved.

Developed by: Ethiopian Artifical Intelligence institute (EAII)
""";
  }
}
