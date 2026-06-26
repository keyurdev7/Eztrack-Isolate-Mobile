import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/theme/color.dart';
import 'package:eztrack_rental/controllers/isolate_controller.dart';
import 'package:eztrack_rental/widgets/form_components.dart';
import '../widgets/common_app_bar.dart';

class UserSetupScreen extends StatefulWidget {
  const UserSetupScreen({Key? key}) : super(key: key);

  @override
  State<UserSetupScreen> createState() => _UserSetupScreenState();
}

class _UserSetupScreenState extends State<UserSetupScreen> {
  final IsolateController _controller = Get.find<IsolateController>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: const CommonAppBar(
        userName: "",
        greeting: "User Setup",
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Info
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Accounts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainTextColor,
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Manage users, roles, and credential access accounts.',
                    style: TextStyle(
                      fontSize: 13,
                      color: lightTextColor,
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by name or email...',
                      prefixIcon: const Icon(Icons.search, color: lightTextColor),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = "";
                                });
                              },
                            )
                          : null,
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Users List
            Expanded(
              child: Obx(() {
                final filteredUsers = _controller.users.where((u) {
                  return u.fullName.toLowerCase().contains(_searchQuery) ||
                      u.email.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredUsers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        const Text(
                          'No users match your search.',
                          style: TextStyle(color: lightTextColor, fontFamily: 'BricolageGrotesque'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return _buildUserCard(user);
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateUserDialog(context);
        },
        backgroundColor: primary,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  Widget _buildUserCard(UserItem user) {
    final isActive = user.status == "Active";
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isActive ? Colors.green.shade50 : Colors.red.shade50,
          child: Icon(
            Icons.person,
            color: isActive ? Colors.green : Colors.red,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              user.fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: mainTextColor,
                fontFamily: 'BricolageGrotesque',
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                user.status,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.green : Colors.red,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              user.email,
              style: const TextStyle(fontSize: 12, color: mainTextColor, fontFamily: 'BricolageGrotesque'),
            ),
            const SizedBox(height: 4),
            Text(
              'Role: ${user.accountType}',
              style: const TextStyle(fontSize: 11, color: lightTextColor, fontFamily: 'BricolageGrotesque'),
            ),
          ],
        ),
        trailing: Switch(
          value: isActive,
          activeColor: primary,
          onChanged: (val) {
            _controller.toggleUserStatus(user.email);
            Get.snackbar(
              'User Updated',
              'User status toggled successfully.',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          },
        ),
      ),
    );
  }

  void _showCreateUserDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String fullName = "";
    String email = "";
    String accountType = "User";
    String status = "Active";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Create User',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: mainTextColor,
                          fontFamily: 'BricolageGrotesque',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),
                  FormTextField(
                    label: 'Full Name',
                    placeholder: 'Enter user full name',
                    isRequired: true,
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    onChanged: (val) => fullName = val,
                  ),
                  const SizedBox(height: 16),
                  FormTextField(
                    label: 'Email Address',
                    placeholder: 'user@company.com',
                    keyboardType: TextInputType.emailAddress,
                    isRequired: true,
                    validator: (val) => val == null || !val.contains('@') ? 'Invalid email' : null,
                    onChanged: (val) => email = val,
                  ),
                  const SizedBox(height: 16),
                  FormTextField(
                    label: 'Password',
                    placeholder: '••••••••',
                    isRequired: true,
                    validator: (val) => val == null || val.length < 4 ? 'Too short' : null,
                    onChanged: (val) {},
                  ),
                  const SizedBox(height: 16),
                  FormDropdownField(
                    label: 'Account Type',
                    placeholder: 'Select Role',
                    selectedValue: accountType,
                    items: const ['Administrator', 'User'],
                    isRequired: true,
                    onChanged: (val) {
                      if (val != null) accountType = val;
                    },
                  ),
                  const SizedBox(height: 16),
                  FormDropdownField(
                    label: 'Status',
                    placeholder: 'Select Status',
                    selectedValue: status,
                    items: const ['Active', 'Inactive'],
                    isRequired: true,
                    onChanged: (val) {
                      if (val != null) status = val;
                    },
                  ),
                  const SizedBox(height: 24),
                  FormSubmitButton(
                    text: 'Create User',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _controller.createUser(UserItem(
                          fullName: fullName,
                          email: email,
                          accountType: accountType,
                          status: status,
                        ));
                        Navigator.pop(context);
                        Get.snackbar(
                          'User Created',
                          'User $fullName successfully added to the system.',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
