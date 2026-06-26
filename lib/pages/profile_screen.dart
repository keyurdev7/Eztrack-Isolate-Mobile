import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/theme/color.dart';
import '../widgets/common_app_bar.dart';
import '../utils/preference_manager.dart';
import '../controllers/login_controller.dart';
import '../widgets/form_components.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LoginController _loginController = Get.find<LoginController>();
  
  final _changePasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _name = 'System Administrator';
  String _email = 'admin@local';
  String _role = 'Administrator';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final fullName = await PreferenceManager.getFullName();
    final email = await PreferenceManager.getUserEmailField();
    
    setState(() {
      if (fullName != null && fullName.isNotEmpty) _name = fullName;
      if (email != null && email.isNotEmpty) _email = email;
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: const CommonAppBar(
        userName: "",
        greeting: "My Account",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Profile Details Card
              _buildProfileDetailsCard(),
              const SizedBox(height: 20),

              // Inline Change Password Form
              _buildChangePasswordCard(),
              const SizedBox(height: 20),

              // Logout Action Button
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: mainTextColor,
              fontFamily: 'BricolageGrotesque',
            ),
          ),
          const SizedBox(height: 16),
          _buildProfileRow('Full Name', _name, Icons.person_outline),
          const Divider(height: 24),
          _buildProfileRow('Email Address', _email, Icons.email_outlined),
          const Divider(height: 24),
          _buildProfileRow('Security Role', _role, Icons.security),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: lightTextColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: mainTextColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChangePasswordCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _changePasswordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: mainTextColor,
                fontFamily: 'BricolageGrotesque',
              ),
            ),
            const SizedBox(height: 16),
            FormTextField(
              label: 'Current Password',
              placeholder: 'Enter current password',
              controller: _currentPasswordController,
              isRequired: true,
              validator: (val) => val == null || val.isEmpty ? 'Current password is required' : null,
            ),
            const SizedBox(height: 16),
            FormTextField(
              label: 'New Password',
              placeholder: 'Enter new password',
              controller: _newPasswordController,
              isRequired: true,
              validator: (val) => val == null || val.length < 6 ? 'Password must be at least 6 characters' : null,
            ),
            const SizedBox(height: 16),
            FormTextField(
              label: 'Confirm New Password',
              placeholder: 'Confirm new password',
              controller: _confirmPasswordController,
              isRequired: true,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Confirm password is required';
                if (val != _newPasswordController.text) return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 24),
            FormSubmitButton(
              text: 'Update Password',
              onPressed: () {
                if (_changePasswordFormKey.currentState!.validate()) {
                  // Simulate password change
                  Get.snackbar(
                    'Success',
                    'Password updated successfully!',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                  _currentPasswordController.clear();
                  _newPasswordController.clear();
                  _confirmPasswordController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.logout, color: red),
        title: const Text(
          'Logout Session',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: red,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        onTap: () {
          _showLogoutDialog();
        },
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout', style: TextStyle(fontFamily: 'BricolageGrotesque')),
          content: const Text('Are you sure you want to logout? All local cache will be cleared.', style: TextStyle(fontFamily: 'BricolageGrotesque')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: lightTextColor, fontFamily: 'BricolageGrotesque')),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _loginController.logout();
              },
              child: const Text('Logout', style: TextStyle(color: red, fontFamily: 'BricolageGrotesque')),
            ),
          ],
        );
      },
    );
  }
}
