import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'api_manager.dart';
import 'api_service.dart';
import 'models/request_models.dart';

/// Example usage of all API calls
/// This file demonstrates how to use each API endpoint
class ApiExampleUsage {
  final ApiService _apiService = ApiService();

  /// Initialize the API manager (call this in main.dart)
  Future<void> initializeApi() async {
    // ApiManager now auto-initializes in constructor
    // No manual initialization needed
  }

  // ==================== AUTHENTICATION EXAMPLES ====================

  /// Example: Login with email and password
  Future<void> loginExample() async {
    try {
      final request = LoginRequest(
        email: 'fjosh@pbf.com',
        password: '2018',
      );

      final response = await _apiService.login(request);

      if (response.success && response.data != null) {
        // Save auth token
        await ApiManager().setAuthToken(response.data!.data!.token ?? '');
        
        debugPrint('Login successful!');
        debugPrint('User: ${response.data!.data!.userDetail?.fullName}');
        debugPrint('Email: ${response.data!.data!.userDetail?.email}');
        debugPrint('Role: ${response.data!.data!.userDetail?.role}');
        debugPrint('Access Code: ${response.data!.data!.userDetail?.accessCode}');
        debugPrint('Can Add Logs: ${response.data!.data!.userDetail?.canAddLogs}');
        debugPrint('Active Status: ${response.data!.data!.userDetail?.activeStatus}');
        debugPrint('Associations Count: ${response.data!.data!.userDetail?.associations?.length ?? 0}');
        debugPrint('Token: ${response.data!.data!.token}');
      } else {
        print('Login failed: ${response.error}');
      }
    } catch (e) {
      print('Login error: $e');
    }
  }

  /// Example: Login with pincode
  Future<void> loginWithPincodeExample() async {
    try {
      final request = LoginUsingPincodeRequest(
        pincode: '7095',
        // deviceId: 'iphone13',
      );

      final response = await _apiService.loginUsingPincode(request);

      if (response.success && response.data != null) {
        await ApiManager().setAuthToken(response.data!.data!.token ?? '');
        print('Pincode login successful!');
        print('User: ${response.data!.data!.userDetail?.fullName}');
        print('Email: ${response.data!.data!.userDetail?.email}');
        print('Role: ${response.data!.data!.userDetail?.role}');
        print('Access Code: ${response.data!.data!.userDetail?.accessCode}');
        print('Can Add Logs: ${response.data!.data!.userDetail?.canAddLogs}');
        print('Active Status: ${response.data!.data!.userDetail?.activeStatus}');
        print('Associations Count: ${response.data!.data!.userDetail?.associations?.length ?? 0}');
        print('Token: ${response.data!.data!.token}');
        
        // Print first few associations for demo
        final associations = response.data!.data!.userDetail?.associations;
        if (associations != null && associations.isNotEmpty) {
          print('First Association:');
          print('  Department: ${associations.first.department?.name}');
          print('  Unit: ${associations.first.unit?.name}');
        }
      } else {
        print('Pincode login failed: ${response.error}');
      }
    } catch (e) {
      print('Pincode login error: $e');
    }
  }

  /// Example: Reset password
  Future<void> resetPasswordExample() async {
    try {
      final request = ResetPasswordRequest(
        password: 'newPassword123',
        confirmPassword: 'newPassword123',
        email: 'user@example.com',
      );

      final response = await _apiService.resetPassword(request);

      if (response.success) {
        print('Password reset successful!');
      } else {
        print('Password reset failed: ${response.error}');
      }
    } catch (e) {
      print('Password reset error: $e');
    }
  }


  /// Example: Delete account
  Future<void> deleteAccountExample() async {
    try {
      final response = await _apiService.deleteAccount();

      if (response.success) {
        print('Account deleted successfully!');
        await ApiManager().clearAuthToken();
      } else {
        print('Account deletion failed: ${response.error}');
      }
    } catch (e) {
      print('Account deletion error: $e');
    }
  }

  // ==================== NOTIFICATION EXAMPLES ====================

  /// Example: Get push notifications
  Future<void> getPushNotificationsExample() async {
    try {
      final response = await _apiService.getPushNotifications();

      if (response.success && response.data != null) {
        print('Notifications loaded: ${response.data!.length} items');
        for (var notification in response.data!) {
          print('Notification: ${notification.title} - ${notification.message}');
        }
      } else {
        print('Failed to load notifications: ${response.error}');
      }
    } catch (e) {
      print('Get notifications error: $e');
    }
  }

  // ==================== DASHBOARD EXAMPLES ====================



  // ==================== LOOKUP DATA EXAMPLES ====================

  /// Example: Get all lookup data
  Future<void> getAllLookupDataExample() async {
    try {
      // Get delay types
      final delayTypesResponse = await _apiService.getDelayTypes();
      if (delayTypesResponse.success) {
        print('Delay types loaded: ${delayTypesResponse.data?.length} items');
      }

      // Get departments
      final departmentsResponse = await _apiService.getDepartments();
      if (departmentsResponse.success) {
        print('Departments loaded: ${departmentsResponse.data?.length} items');
      }

      // Get units
      final unitsResponse = await _apiService.getUnits();
      if (unitsResponse.success) {
        print('Units loaded: ${unitsResponse.data?.length} items');
      }

      // Get shifts
      final shiftsResponse = await _apiService.getShifts();
      if (shiftsResponse.success) {
        print('Shifts loaded: ${shiftsResponse.data?.length} items');
      }

      // Get companies
      final companiesResponse = await _apiService.getCompanies();
      if (companiesResponse.success) {
        print('Companies loaded: ${companiesResponse.data?.length} items');
      }

    } catch (e) {
      print('Get lookup data error: $e');
    }
  }


  // ==================== TOT LOG EXAMPLES ====================



  /// Example: Generic approve/reject
  Future<void> approveRejectExample() async {
    try {
      final request = ApproveRejectRequest(
        comment: 'Approved',
        reason: 'Meets all criteria',
      );

      // Example: Approve TOT log with ID 123
      final response = await _apiService.approveReject(
        'TOTLog',
        '123',
        'Approved',
        request,
      );

      if (response.success) {
        print('Item approved successfully!');
      } else {
        print('Failed to approve item: ${response.error}');
      }
    } catch (e) {
      print('Approve/reject error: $e');
    }
  }

  // ==================== COMPLETE WORKFLOW EXAMPLE ====================

  /// Example: Complete workflow - Login, get data, create log, approve

}

/// Widget to demonstrate API usage in UI
class ApiExampleWidget extends StatefulWidget {
  const ApiExampleWidget({super.key});

  @override
  State<ApiExampleWidget> createState() => _ApiExampleWidgetState();
}

class _ApiExampleWidgetState extends State<ApiExampleWidget> {
  final ApiExampleUsage _apiExample = ApiExampleUsage();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _apiExample.initializeApi();
  }

  Future<void> _runExample(Future<void> Function() example) async {
    setState(() => _isLoading = true);
    try {
      await example();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Examples'),
      ),
      body: _isLoading
          ?  Center(child: CircularProgressIndicator(),)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Authentication Examples',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _runExample(_apiExample.loginExample),
                    child: const Text('Login Example'),
                  ),
                  ElevatedButton(
                    onPressed: () => _runExample(_apiExample.loginWithPincodeExample),
                    child: const Text('Login with Pincode'),
                  ),
                  ElevatedButton(
                    onPressed: () => _runExample(_apiExample.resetPasswordExample),
                    child: const Text('Reset Password'),
                  ),

                  
                  const SizedBox(height: 16),
                  const Text(
                    'Data Examples',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  
                  const SizedBox(height: 16),
                  const Text(
                    'Create Examples',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                ],
              ),
            ),
    );
  }
}
