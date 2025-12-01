import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/widgets/app_scaffold.dart';
import 'package:oro_ticket_booking_app/core/constants/typography.dart';

import '../controllers/settings_controller.dart';
import 'profile_edit_view.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "settings".tr,
      currentBottomNavIndex: 2,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Center(
              child: Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                        icon: const Icon(Icons.edit, size: 16, color: Colors.green),
                        label: Text("edit_profile".tr),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.green),
                          foregroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Preferences Section
            _buildCollapsibleSection(
              title: "preferences".tr,
              icon: Icons.settings,
              children: [
                // Language Preference
                Text("language".tr, style: AppTextStyles.body1),
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
                          .map((lang) => DropdownMenuItem(
                                value: lang['code'],
                                child: Text('${lang['code']!.toUpperCase()} — ${lang['nativeName']}'),
                              ))
                          .toList(),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),

            // Support Section
            _buildCollapsibleSection(
              title: "support_feedback".tr,
              icon: Icons.support,
              children: [
                // Complaint Category
                Text("category".tr, style: AppTextStyles.body1),
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
                      hint: Text("select_category".tr),
                      underline: const SizedBox(),
                      onChanged: (value) {
                        if (value != null) controller.selectedCategory.value = value;
                      },
                      items: categories
                          .map((category) => DropdownMenuItem<String>(
                                value: category['name'] as String,
                                child: Text(category['name'] as String),
                              ))
                          .toList(),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Complaint & Feedback
                Text("message".tr, style: AppTextStyles.body1),
                const SizedBox(height: 8),
                Obx(() => TextFormField(
                      initialValue: controller.feedback.value,
                      onChanged: (val) => controller.feedback.value = val,
                      decoration: InputDecoration(
                        hintText: "write_complaint".tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      maxLines: 4,
                    )),
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
                    child: Text("submit_feedback".tr),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Policies Section
            _buildCollapsibleSection(
              title: "policies_legal".tr,
              icon: Icons.policy,
              children: [
                _buildPolicyItem(
                  icon: Icons.description,
                  title: "terms_of_service".tr,
                  onTap: () => _showPolicyDialog("terms_of_service".tr, "terms_content".tr),
                ),
                const Divider(),
                _buildPolicyItem(
                  icon: Icons.privacy_tip,
                  title: "privacy_policy".tr,
                  onTap: () => _showPolicyDialog("privacy_policy".tr, "privacy_content".tr),
                ),
                const Divider(),
                _buildPolicyItem(
                  icon: Icons.help,
                  title: "help_support".tr,
                  onTap: () => _showPolicyDialog("help_support".tr, "help_content".tr),
                ),
                const Divider(),
                _buildPolicyItem(
                  icon: Icons.info,
                  title: "about".tr,
                  onTap: () => _showPolicyDialog("about".tr, "about_content".tr),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Logout Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: controller.logout,
                icon: const Icon(Icons.logout),
                label: Text("logout".tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }


  Widget _buildPolicyItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: AppTextStyles.body1),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildCollapsibleSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title, style: AppTextStyles.heading3),
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
  }

  void _showPolicyDialog(String title, String content) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("close".tr),
          ),
        ],
      ),
    );
  }
}
