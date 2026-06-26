import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/theme/color.dart';
import 'package:eztrack_rental/controllers/isolate_controller.dart';
import 'package:eztrack_rental/controllers/login_controller.dart';
import '../widgets/common_app_bar.dart';
import 'settings_list_screen.dart';
import 'main_screen.dart';

class ProjectsListScreen extends StatefulWidget {
  final bool isTab;
  const ProjectsListScreen({Key? key, this.isTab = false}) : super(key: key);

  @override
  State<ProjectsListScreen> createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends State<ProjectsListScreen> {
  final IsolateController controller = Get.put(IsolateController());
  final LoginController loginController = Get.find<LoginController>();
  bool _isSidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: isWide ? const Color(0xFFF4F6F9) : lightBackground,
      appBar: (isWide || widget.isTab)
          ? null
          : const CommonAppBar(userName: "", greeting: "Projects"),
      body: Obx(() {
        if (isWide && !widget.isTab) {
          return Row(
            children: [
              // Wide sidebar navigation
              _buildWideSidebar(context),
              // Thin vertical divider
              Container(width: 1, color: Colors.grey.shade200),
              // Active screen content
              Expanded(child: _buildWideMainContent(context)),
            ],
          );
        } else if (isWide && widget.isTab) {
          return _buildWideMainContent(context);
        } else {
          return _buildMobileLayout(context);
        }
      }),
    );
  }

  // --- Wide Sidebar Navigation Widget ---

  Widget _buildWideSidebar(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: _isSidebarCollapsed ? 72 : 260,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sidebar Logo
              _buildSidebarHeader(),
              const SizedBox(height: 20),

              // Navigation Links
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildSidebarItem(
                      icon: Icons.dashboard_outlined,
                      activeIcon: Icons.dashboard,
                      label: 'Dashboard',
                      isSelected: false,
                      onTap: () {
                        if (controller.selectedProject.value != null) {
                          Get.offAllNamed('/main');
                        } else {
                          Get.snackbar(
                            'Project Required',
                            'Please select a turnaround project to view the dashboard.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: primary,
                            colorText: Colors.white,
                            borderRadius: 8,
                            margin: const EdgeInsets.all(16),
                          );
                        }
                      },
                    ),
                    _buildSidebarItem(
                      icon: Icons.account_tree_outlined,
                      activeIcon: Icons.account_tree,
                      label: 'Projects',
                      isSelected: true,
                      onTap: () {
                        // Already on Projects screen
                      },
                    ),
                    _buildSidebarItem(
                      icon: Icons.settings_outlined,
                      activeIcon: Icons.settings,
                      label: 'Settings',
                      isSelected: false,
                      onTap: () => Get.to(() => const SettingsListScreen()),
                    ),
                  ],
                ),
              ),

              // Bottom Section: Profile + Logout
              _buildSidebarProfileSection(context),
            ],
          ),
        ),

        // Sidebar Collapse/Expand Toggle Button floating on right border
        Positioned(
          right: -16,
          top: MediaQuery.of(context).size.height / 2 - 20,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isSidebarCollapsed = !_isSidebarCollapsed;
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _isSidebarCollapsed ? Icons.chevron_right : Icons.chevron_left,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: _isSidebarCollapsed
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.layers, color: primary, size: 24),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.layers, color: primary, size: 24),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'EZ',
                                style: TextStyle(
                                  color: primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'BricolageGrotesque',
                                ),
                              ),
                              Text(
                                'TRAK',
                                style: TextStyle(
                                  color: mainTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'BricolageGrotesque',
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Software Solutions',
                            style: TextStyle(
                              color: primary,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'BricolageGrotesque',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    if (_isSidebarCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Tooltip(
          message: label,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFF2ED) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected
                    ? const Color(0xFFF05A28)
                    : const Color(0xFF5A6A85),
                size: 22,
              ),
              onPressed: onTap,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF2ED) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected
                    ? const Color(0xFFF05A28)
                    : const Color(0xFF5A6A85),
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFFF05A28)
                      : const Color(0xFF5A6A85),
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarProfileSection(BuildContext context) {
    if (_isSidebarCollapsed) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 16),
            Tooltip(
              message: "Logout",
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  border: Border.all(color: primary, width: 1.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.logout, color: primary, size: 18),
                  onPressed: () => _showLogoutDialog(context),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Profile block
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'System Administrator',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F2C59),
                          fontFamily: 'BricolageGrotesque',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFF8C9BA5),
                          fontFamily: 'BricolageGrotesque',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Logout button
          OutlinedButton.icon(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout, size: 16, color: primary),
            label: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: primary,
                fontFamily: 'BricolageGrotesque',
              ),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 42),
              side: const BorderSide(color: primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(fontFamily: 'BricolageGrotesque'),
          ),
          content: const Text(
            'Are you sure you want to logout? All local cache will be cleared.',
            style: TextStyle(fontFamily: 'BricolageGrotesque'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: lightTextColor,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await loginController.logout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: red,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- Wide Main Content Widget ---

  Widget _buildWideMainContent(BuildContext context) {
    // Group projects by department
    final Map<String, List<IsolateProject>> groupedProjects = {};
    for (var project in controller.projects) {
      final dept = project.department;
      if (!groupedProjects.containsKey(dept)) {
        groupedProjects[dept] = [];
      }
      groupedProjects[dept]!.add(project);
    }

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: controller.projects.isEmpty
                  ? Center(
                      child: Text(
                        'No turnaround projects configured.',
                        style: TextStyle(
                          color: lightTextColor,
                          fontSize: 16,
                          fontFamily: 'BricolageGrotesque',
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: groupedProjects.entries.map((entry) {
                          final dept = entry.key;
                          final list = entry.value;
                          // If department is Turnaround, pluralize to Turnarounds to match screenshot
                          final title = dept.toLowerCase() == 'turnaround'
                              ? 'Turnarounds'
                              : dept;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F2C59),
                                        fontFamily: 'BricolageGrotesque',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Wrap(
                                  spacing: 24,
                                  runSpacing: 24,
                                  children: list.map((project) {
                                    return _buildWideProjectCard(
                                      context,
                                      project,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              '© 2026 - EZTRAK Software, LLC. All Rights Reserved.',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF8C9BA5),
                fontFamily: 'BricolageGrotesque',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideProjectCard(BuildContext context, IsolateProject project) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: const Color(0xFFEDF1F7), // Soft blue-grey card background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            controller.selectedProject.value = project;
            Get.offAllNamed('/main', arguments: 2);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_tree_outlined, // Organization chart tree icon
                  color: primary,
                  size: 26,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2C59),
                      fontFamily: 'BricolageGrotesque',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Mobile Layout Widget ---

  Widget _buildMobileLayout(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 800;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(isWide ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Turnarounds',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F2C59),
                fontFamily: 'BricolageGrotesque',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Choose an active project to track drawings, isolations, blinds, and TWR items.',
              style: TextStyle(
                fontSize: 10,
                color: lightTextColor,
                fontFamily: 'BricolageGrotesque',
              ),
            ),
            const SizedBox(height: 20),
            // Projects List
            Expanded(
              child: controller.projects.isEmpty
                  ? Center(
                      child: Text(
                        'No turnaround projects configured.',
                        style: TextStyle(
                          color: lightTextColor,
                          fontFamily: 'BricolageGrotesque',
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(const Duration(milliseconds: 500));
                      },
                      color: primary,
                      child: ListView.builder(
                        itemCount: controller.projects.length,
                        itemBuilder: (context, index) {
                          final project = controller.projects[index];
                          return _buildProjectCard(
                            context,
                            project,
                            controller,
                          );
                        },
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            // Footer text
            Center(
              child: Text(
                '© 2026 - EZTRAK Software, LLC. All Rights Reserved.',
                style: TextStyle(
                  fontSize: 10,
                  color: lightTextColor,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    IsolateProject project,
    IsolateController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            controller.selectedProject.value = project;
            Get.offAllNamed('/main', arguments: 2);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Project unit badge
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      project.unitNumber,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primary,
                        fontFamily: 'BricolageGrotesque',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Project detail labels
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainTextColor,
                          fontFamily: 'BricolageGrotesque',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildTagBadge(project.department),
                          const SizedBox(width: 8),
                          _buildTagBadge(project.year),
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow indicator
                const Icon(Icons.arrow_forward_ios, size: 16, color: primary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: lightTextColor,
          fontFamily: 'BricolageGrotesque',
        ),
      ),
    );
  }
}
