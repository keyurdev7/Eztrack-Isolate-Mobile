
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:eztrack_rental/api/api_service.dart';
import 'package:eztrack_rental/api/api_manager.dart';
import 'package:eztrack_rental/api/models/request_models.dart';
import 'package:eztrack_rental/api/models/response_models.dart';
import 'package:eztrack_rental/utils/preference_manager.dart';
import 'package:eztrack_rental/services/fcm_service.dart';



class ManageLoginController extends GetxController {
  final ApiService _apiService = ApiService();
  
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoggedIn = false.obs;
  final Rx<UserDetail?> userDetail = Rx<UserDetail?>(null);
  final RxString authToken = ''.obs;
  
  // Login mode: true for email/password, false for access code
  final RxBool isEmailPasswordMode = true.obs;
  
  // Email/Password form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool obscurePassword = true.obs;
  
  // Access code form controllers
  final List<TextEditingController> pinControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  @override
  void onInit() {
    super.onInit();

    _checkLoginStatus();
  }

  @override
  void onClose() {
    // Dispose email/password controllers
    emailController.dispose();
    passwordController.dispose();
    
    // Dispose pin controllers
    for (var controller in pinControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.onClose();
  }

  /// Toggle between email/password and access code login modes
  void toggleLoginMode() {
    isEmailPasswordMode.value = !isEmailPasswordMode.value;
    clearError();
    // Clear form fields when switching modes
    if (isEmailPasswordMode.value) {
      // Switching to email/password mode - clear pin fields
      for (var controller in pinControllers) {
        controller.clear();
      }
    } else {
      // Switching to access code mode - clear email/password fields
      emailController.clear();
      passwordController.clear();
    }
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

  /// Login using access code/pincode
  Future<bool> loginWithAccessCode(String accessCode, String deviceId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get FCM token
      String? fcmToken;
      try {
        // fcmToken = await FCMService.to.getFCMToken();
        fcmToken = DateTime.now().toString();
        print('🔔 Manage Login Controller - FCM Token for access code login: ${fcmToken?.substring(0, 20)}...');
      } catch (e) {
        print('⚠️ Manage Login Controller - Failed to get FCM token: $e');
      }

      final request = LoginUsingPincodeRequest(
        pincode: accessCode,
        // deviceId: fcmToken ?? deviceId, // Use FCM token as deviceId if available
      );

      final response = await _apiService.loginUsingPincode(request);

      if (response.success && response.data != null) {
        // Save login data to preferences
        await PreferenceManager.saveLoginData(response.data!.data!);
        await PreferenceManager.setLoggedIn(true);
        await PreferenceManager.setUserCode(accessCode);
        await PreferenceManager.setFirstTime(false);

        // Update observable variables
        isLoggedIn.value = true;
        authToken.value = response.data!.data!.token ?? '';
        userDetail.value = response.data!.data!.userDetail;

        isLoading.value = false;
        return true;
      } else {
        errorMessage.value = response.error ?? 'Login failed. Please try again.';
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      isLoading.value = false;
      return false;
    }
  }

  /// Login using email and password
  Future<bool> loginWithEmailPassword(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get FCM token
      String? fcmToken;
      try {
        // fcmToken = await FCMService.to.getFCMToken();
        fcmToken = DateTime.now().toString();
        print('🔔 Manage Login Controller - FCM Token for email login: ${fcmToken?.substring(0, 20)}...');
      } catch (e) {
        print('⚠️ Manage Login Controller - Failed to get FCM token: $e');
      }

      final request = LoginRequest(
        email: email,
        password: password,
        deviceId: fcmToken, // Include FCM token as deviceId
      );

      final response = await _apiService.login(request);

      if (response.success && response.data != null) {
        // Save login data to preferences
        await PreferenceManager.saveLoginData(response.data!.data!);
        await PreferenceManager.setLoggedIn(true);
        await PreferenceManager.setFirstTime(false);

        // Update observable variables
        isLoggedIn.value = true;
        authToken.value = response.data!.data!.token ?? '';
        userDetail.value = response.data!.data!.userDetail;

        isLoading.value = false;
        return true;
      } else {
        errorMessage.value = response.error ?? 'Login failed. Please try again.';
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      isLoading.value = false;
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
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
      
      // Clear form controllers
      emailController.clear();
      passwordController.clear();
      for (var controller in pinControllers) {
        controller.clear();
      }
      
      // Navigate to login screen and clear navigation stack
      Get.offAllNamed('/manage-login');
    } catch (e) {
      print('Error during logout: $e');
      // Even if there's an error, still navigate to login screen
      Get.offAllNamed('/manage-login');
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
        errorMessage.value = response.error ?? 'Failed to delete account. Please try again.';
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred while deleting account. Please try again.';
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
    Get.offAllNamed('/main');
  }

  /// Navigate to welcome screen
  void navigateToWelcomeScreen() {
    Get.offAllNamed('/login');
  }

  /// Navigate to login screen
  void navigateToLoginScreen() {
    Get.offAllNamed('/manage-login');
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
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

  /// Get entered access code
  String getEnteredAccessCode() {
    return pinControllers.map((controller) => controller.text).join();
  }

  /// Validate access code
  bool validateAccessCode() {
    final accessCode = getEnteredAccessCode();
    return accessCode.length == 4;
  }

  /// Validate email
  bool validateEmail(String email) {
    return email.isNotEmpty && email.contains('@') && email.contains('.');
  }

  /// Validate password
  bool validatePassword(String password) {
    return password.isNotEmpty;
    // return password.isNotEmpty && password.length >= 6
  }

  /// Get user role
  String? get userRole => userDetail.value?.role;
  // String? get userRole => userDetail.value?.role

  /// Get user name
  String? get userName => userDetail.value?.name ?? userDetail.value?.fullName;
  // String? get userName => userDetail.value?.name ?? userDetail.value?.fullName

  /// Get user ID
  int? get userId => userDetail.value?.id;

  /// Check if user can add logs
  bool get canAddLogs => userDetail.value?.canAddLogs ?? false;

  /// Check if user is approved
  bool get isApproved => userDetail.value?.isApproved ?? false;

  /// Check if notifications are disabled
  bool get disableNotifications => userDetail.value?.disableNotifications ?? false;

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
      return associations.map((assoc) => assoc.department).where((dept) => dept != null).cast<Department>().toList();
    }
    return null;
  }

  /// Get units from associations
  List<Unit>? get units {
    final associations = userDetail.value?.associations;
    if (associations != null) {
      return associations.map((assoc) => assoc.unit).where((unit) => unit != null).cast<Unit>().toList();
    }
    return null;
  }
}

