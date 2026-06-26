import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:eztrack_rental/api/api_service.dart';
import 'package:eztrack_rental/api/api_manager.dart';
import 'package:eztrack_rental/api/models/request_models.dart';
import 'package:eztrack_rental/api/models/response_models.dart';
import 'package:eztrack_rental/utils/preference_manager.dart';
import 'package:eztrack_rental/services/fcm_service.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoggedIn = false.obs;
  final Rx<UserDetail?> userDetail = Rx<UserDetail?>(null);
  final RxString authToken = ''.obs;

  // Form controllers
  late List<TextEditingController> pinControllers;
  late List<FocusNode> focusNodes;

  @override
  void onInit() {
    super.onInit();
    pinControllers = List.generate(4, (_) => TextEditingController());
    focusNodes = List.generate(4, (_) => FocusNode());
    _checkLoginStatus();
  }

  @override
  void onClose() {
    for (var controller in pinControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.onClose();
  }

  /// Check if user is already logged in
  Future<void> _checkLoginStatus() async {
    try {
      final isLoggedInStatus = await PreferenceManager.isLoggedIn();
      final token = await PreferenceManager.getToken();
      final user = await PreferenceManager.getUserDetail();

      isLoggedIn.value = isLoggedInStatus && token != null;
      authToken.value = token ?? '';
      userDetail.value = user;
    } catch (e) {
      print('Error checking login status: $e');
    }
  }

  /// Login using pincode
  Future<bool> loginWithPincode(String pincode, String deviceId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Simulate a brief API loading delay for demo aesthetics
      await Future.delayed(const Duration(milliseconds: 800));

      final mockUserDetail = UserDetail(
        id: 1,
        role: 'Administrator',
        name: 'System Administrator',
        fullName: 'System Administrator',
        select2Text: 'System Administrator',
        userName: 'admin',
        isApproved: true,
        canAddLogs: true,
        disableNotifications: false,
        changePassword: false,
        activeStatus: 'Active',
      );

      await PreferenceManager.setLoggedIn(true);
      await PreferenceManager.setUserCode(pincode);
      await PreferenceManager.setFirstTime(false);
      await PreferenceManager.setToken('dummy_token_123');
      await PreferenceManager.setUserDetail(mockUserDetail);
      await PreferenceManager.setUserEmailField('admin@local');
      await PreferenceManager.setFullName('System Administrator');
      await PreferenceManager.setUserRole('Administrator');

      // Update observable variables
      isLoggedIn.value = true;
      authToken.value = 'dummy_token_123';
      userDetail.value = mockUserDetail;

      isLoading.value = false;
      return true;
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      isLoading.value = false;
      return false;
    }
  }

  /// Login using email and password

  /// Logout user
  Future<void> logout() async {
    try {
      String token = await ApiManager().getAuthToken();
      // Clear all data from SharedPreferences
      await PreferenceManager.logout();
      //
      // // Clear auth token from ApiManager
      await ApiManager().clearAuthToken();

      // await ApiManager().setAuthToken(token);

      // Clear observable variables
      isLoggedIn.value = false;
      authToken.value = '';
      userDetail.value = null;
      errorMessage.value = '';
      isLoading.value = false;

      // Reset PIN fields for next login
      for (var c in pinControllers) {
        c.clear();
      }

      // Navigate to login screen and clear navigation stack
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error during logout: $e');
      // Even if there's an error, still navigate to welcome screen
      Get.offAllNamed('/login');
      // Get.offAllNamed('/welcome');
    }
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.deleteAccount();

      if (response.success) {
        // Account deleted successfully, now logout
        await logout();
        return true;
      } else {
        errorMessage.value =
            response.error ?? 'Failed to delete account. Please try again.';
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      errorMessage.value =
          'An error occurred while deleting account. Please try again.';
      isLoading.value = false;
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  /// Navigate to main screen
  void navigateToMainScreen() {
    // Get.offAllNamed('/projects');
    Get.offAllNamed('/main');
  }

  /// Navigate to welcome screen
  void navigateToWelcomeScreen() {
    // Get.offAllNamed('/welcome');
    Get.offAllNamed('/login');
  }

  /// Navigate to login screen
  void navigateToLoginScreen() {
    Get.offAllNamed('/login');
  }

  /// Handle pin input navigation
  void handlePinInput(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 3) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    }
    clearError();
  }

  /// Get entered pincode
  String getEnteredPincode() {
    return pinControllers.map((controller) => controller.text).join();
  }

  /// Validate pincode
  bool validatePincode() {
    final pincode = getEnteredPincode();
    return pincode.length == 4;
  }

  /// Get user role
  String? get userRole => userDetail.value?.role;

  /// Get user name
  String? get userName => userDetail.value?.name ?? userDetail.value?.fullName;

  /// Get user ID
  int? get userId => userDetail.value?.id;

  /// Check if user can add logs
  bool get canAddLogs => userDetail.value?.canAddLogs ?? false;

  /// Check if user is approved
  bool get isApproved => userDetail.value?.isApproved ?? false;

  /// Check if notifications are disabled
  bool get disableNotifications =>
      userDetail.value?.disableNotifications ?? false;

  /// Get active status
  String? get activeStatus => userDetail.value?.activeStatus;

  /// Get access code
  String? get accessCode => userDetail.value?.accessCode;

  /// Get formatted access code
  String? get formattedAccessCode => userDetail.value?.formattedAccessCode;

  /// Get associations
  List<Association>? get associations => userDetail.value?.associations;

  /// Get departments from associations
  List<Department>? get departments {
    final associations = userDetail.value?.associations;
    if (associations != null) {
      return associations
          .map((assoc) => assoc.department)
          .where((dept) => dept != null)
          .cast<Department>()
          .toList();
    }
    return null;
  }

  /// Get units from associations
  List<Unit>? get units {
    final associations = userDetail.value?.associations;
    if (associations != null) {
      return associations
          .map((assoc) => assoc.unit)
          .where((unit) => unit != null)
          .cast<Unit>()
          .toList();
    }
    return null;
  }
}
