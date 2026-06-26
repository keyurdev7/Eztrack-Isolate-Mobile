import 'package:eztrack_rental/pages/projects_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/theme/color.dart';
import 'package:eztrack_rental/controllers/isolate_controller.dart';
import 'package:eztrack_rental/controllers/login_controller.dart';
import 'package:eztrack_rental/services/update_service.dart';
import 'dashbord.dart';
import 'twr_tags_screen.dart';
import 'profile_screen.dart';
import 'settings_list_screen.dart';
import 'user_setup_screen.dart';

// MainScreenState Controller to allow cross-tab navigation
class MainScreenState extends GetxController {
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is int) {
      currentIndex.value = Get.arguments as int;
    }
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainScreenState _state = Get.put(MainScreenState());
  final IsolateController _isolateController = Get.find<IsolateController>();
  final LoginController _loginController = Get.find<LoginController>();

  bool _isSidebarCollapsed = false;

  final List<Widget> _screens = [
    const DashbordPage(),
    const ProjectsListScreen(isTab: true),
    const TwrTagsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 800;

    return Obx(() {
      if (isWide) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F6F9),
          body: Row(
            children: [
              // Wide sidebar navigation
              _buildWideSidebar(context),
              // Thin vertical divider
              Container(width: 1, color: Colors.grey.shade200),
              // Active screen content
              Expanded(child: _screens[_state.currentIndex.value]),
            ],
          ),
        );
      } else {
        return Scaffold(
          body: _screens[_state.currentIndex.value],
          drawer: _buildSideDrawer(context),
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      }
    });
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
                      isSelected: _state.currentIndex.value == 0,
                      onTap: () {
                        if (_isolateController.selectedProject.value != null) {
                          _state.changeTab(0);
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
                      isSelected:
                          _state.currentIndex.value == 1 ||
                          _state.currentIndex.value == 2,
                      onTap: () {
                        if (_isolateController.selectedProject.value == null) {
                          _state.changeTab(1);
                        } else {
                          _state.changeTab(2);
                        }
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

  Widget _buildSidebarActionItem({
    required IconData icon,
    required String label,
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              icon: Icon(icon, color: const Color(0xFF5A6A85), size: 22),
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF5A6A85), size: 22),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5A6A85),
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
              'Logout Session',
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

  // --- Mobile Bottom Navigation and Drawer ---

  Widget _buildBottomNavigationBar() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard,
                label: 'Dashboard',
                index: 0,
              ),
              _buildBottomNavItem(
                icon: Icons.account_tree_outlined,
                activeIcon: Icons.account_tree,
                label: 'Projects',
                index: 1,
              ),
              _buildBottomNavItem(
                icon: Icons.menu,
                activeIcon: Icons.menu,
                label: 'More',
                index: 99, // Magic number to open drawer
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final bool isSelected = (index == 99)
        ? false
        : _state.currentIndex.value == index;

    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () {
            if (index == 99) {
              Scaffold.of(context).openDrawer();
            } else {
              _state.changeTab(index);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? primary : bottomBarTextColor,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected ? primary : bottomBarTextColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontFamily: 'BricolageGrotesque',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSideDrawer(BuildContext context) {
    final activeProject = _isolateController.selectedProject.value;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drawer Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.layers,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'EZTRAK ISOLATE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'BricolageGrotesque',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activeProject?.name ?? 'No Project selected',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontFamily: 'BricolageGrotesque',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Drawer items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _buildDrawerItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  onTap: () {
                    Navigator.pop(context);
                    _state.changeTab(0);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.account_tree,
                  label: 'Projects',
                  onTap: () {
                    Navigator.pop(context);
                    _state.changeTab(1);
                  },
                ),

                const Divider(),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  label: 'Project Configurations',
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const SettingsListScreen());
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.people_outline,
                  label: 'User Setup Control',
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const UserSetupScreen());
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person_outline,
                  label: 'Account Profile',
                  onTap: () {
                    Navigator.pop(context);
                    _state.changeTab(3);
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.swap_horiz,
                  label: 'Switch Project',
                  onTap: () {
                    Navigator.pop(context);
                    Get.offAllNamed('/projects');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.logout,
                  label: 'Logout Session',
                  textColor: red,
                  iconColor: red,
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),

          // Version info
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Version ${Get.find<UpdateService>().getCurrentVersion()}',
              style: TextStyle(
                fontSize: 11,
                color: lightTextColor,
                fontFamily: 'BricolageGrotesque',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? bottomBarTextColor, size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textColor ?? mainTextColor,
          fontFamily: 'BricolageGrotesque',
        ),
      ),
      onTap: onTap,
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
                await _loginController.logout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: red, fontFamily: 'BricolageGrotesque'),
              ),
            ),
          ],
        );
      },
    );
  }
}
