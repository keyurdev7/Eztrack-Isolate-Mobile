import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/theme/color.dart';
import 'package:eztrack_rental/controllers/isolate_controller.dart';
import '../widgets/common_app_bar.dart';

class SettingsListScreen extends StatelessWidget {
  const SettingsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: const CommonAppBar(
        userName: "",
        greeting: "Project Settings",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configuration Control',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: mainTextColor,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Manage lookup fields, sizes, ratings, and active project settings.',
                style: TextStyle(
                  fontSize: 13,
                  color: lightTextColor,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              const SizedBox(height: 24),

              // Section: Project Settings
              _buildSectionTitle('Project General Settings'),
              const SizedBox(height: 8),
              _buildSettingsCategoryCard(
                context,
                title: 'Unit Numbers',
                subtitle: 'Configure industrial unit identifier codes',
                icon: Icons.numbers,
                categoryKey: 'unit number',
              ),
              _buildSettingsCategoryCard(
                context,
                title: 'Years',
                subtitle: 'Manage active turnaround year scopes',
                icon: Icons.calendar_today,
                categoryKey: 'year',
              ),
              _buildSettingsCategoryCard(
                context,
                title: 'Departments',
                subtitle: 'Add or modify organizational departments',
                icon: Icons.business,
                categoryKey: 'department',
              ),
              const SizedBox(height: 24),

              // Section: Tag configurations
              _buildSectionTitle('Tag Parameters'),
              const SizedBox(height: 8),
              _buildSettingsCategoryCard(
                context,
                title: 'Blind Types',
                subtitle: 'Manage slips, blind flanges, spectacles',
                icon: Icons.blur_linear,
                categoryKey: 'blind type',
              ),
              _buildSettingsCategoryCard(
                context,
                title: 'Flange Sizes',
                subtitle: 'Manage standard sizes (e.g. 1\", 2\", 4\")',
                icon: Icons.aspect_ratio,
                categoryKey: 'size',
              ),
              _buildSettingsCategoryCard(
                context,
                title: 'Flange Types',
                subtitle: 'Manage faces (Raised, Flat, Ring Joint)',
                icon: Icons.settings_ethernet,
                categoryKey: 'flange type',
              ),
              _buildSettingsCategoryCard(
                context,
                title: 'Ratings',
                subtitle: 'Manage pressure ratings (150#, 300#)',
                icon: Icons.speed,
                categoryKey: 'rating',
              ),
              _buildSettingsCategoryCard(
                context,
                title: 'Loop Numbers',
                subtitle: 'Configure instrument loop identifiers',
                icon: Icons.loop,
                categoryKey: 'loop #',
              ),
              _buildSettingsCategoryCard(
                context,
                title: 'Scaffold Heights',
                subtitle: 'Height parameters (e.g. 6 ft, 12 ft)',
                icon: Icons.architecture,
                categoryKey: 'scaffold height',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: primary,
          letterSpacing: 0.8,
          fontFamily: 'BricolageGrotesque',
        ),
      ),
    );
  }

  Widget _buildSettingsCategoryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String categoryKey,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: primary, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: mainTextColor,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: lightTextColor, fontFamily: 'BricolageGrotesque'),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: lightTextColor),
        onTap: () {
          Get.to(() => CategoryEditorScreen(categoryName: title, categoryKey: categoryKey));
        },
      ),
    );
  }
}

class CategoryEditorScreen extends StatelessWidget {
  final String categoryName;
  final String categoryKey;

  const CategoryEditorScreen({
    Key? key,
    required this.categoryName,
    required this.categoryKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IsolateController controller = Get.find<IsolateController>();

    // Retrieve active list based on category key
    RxList<String> getActiveList() {
      switch (categoryKey) {
        case 'unit number':
          return controller.unitNumbers;
        case 'year':
          return controller.years;
        case 'department':
          return controller.departments;
        case 'blind type':
          return controller.blindTypes;
        case 'size':
          return controller.flangeSizes;
        case 'flange type':
          return controller.flangeTypes;
        case 'rating':
          return controller.flangeRatings;
        case 'loop #':
          return controller.loopNumbers;
        case 'scaffold height':
          return controller.scaffoldHeights;
        default:
          return <String>[].obs;
      }
    }

    final activeList = getActiveList();

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: mainTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          categoryName,
          style: const TextStyle(
            color: mainTextColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: primary),
            onPressed: () {
              _showAddOptionDialog(context, controller, categoryName, categoryKey);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (activeList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.list, size: 48, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                const Text(
                  'No configurations added yet.',
                  style: TextStyle(color: lightTextColor, fontFamily: 'BricolageGrotesque'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: activeList.length,
          itemBuilder: (context, index) {
            final item = activeList[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  item,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: mainTextColor,
                    fontFamily: 'BricolageGrotesque',
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () {
                    _showDeleteConfirmation(context, controller, categoryKey, item);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showAddOptionDialog(
    BuildContext context,
    IsolateController controller,
    String name,
    String key,
  ) {
    final TextEditingController textController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add $name', style: const TextStyle(fontFamily: 'BricolageGrotesque')),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Enter name or display value',
                hintStyle: TextStyle(fontFamily: 'BricolageGrotesque'),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? 'Value is required' : null,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: lightTextColor, fontFamily: 'BricolageGrotesque')),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              child: const Text('Save', style: TextStyle(color: Colors.white, fontFamily: 'BricolageGrotesque')),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  controller.addSettingItem(key, textController.text.trim());
                  Navigator.pop(context);
                  Get.snackbar(
                    'Item Added',
                    'Successfully added "${textController.text}" to $name.',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    IsolateController controller,
    String key,
    String value,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete', style: TextStyle(fontFamily: 'BricolageGrotesque')),
          content: Text('Are you sure you want to remove "$value"? This action cannot be undone.', style: const TextStyle(fontFamily: 'BricolageGrotesque')),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: lightTextColor, fontFamily: 'BricolageGrotesque')),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete', style: TextStyle(color: Colors.white, fontFamily: 'BricolageGrotesque')),
              onPressed: () {
                controller.removeSettingItem(key, value);
                Navigator.pop(context);
                Get.snackbar(
                  'Item Removed',
                  'Removed "$value" successfully.',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
