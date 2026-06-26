import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/api/api_service.dart';
import 'package:eztrack_rental/api/models/request_models.dart';
import 'package:eztrack_rental/utils/preference_manager.dart';

class ForgotPasswordController extends GetxController {
  final ApiService _apiService = ApiService();
  
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Form controllers
  final TextEditingController emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadUserEmail();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  /// Load user email from stored preferences
  Future<void> _loadUserEmail() async {
    try {
      // Try to get email from user detail first
      final userDetail = await PreferenceManager.getUserDetail();
      if (userDetail?.email != null) {
        emailController.text = userDetail!.email!;
        return;
      }
      
      // Fallback to stored email
      final email = await PreferenceManager.getEmail();
      if (email != null) {
        emailController.text = email;
      }
    } catch (e) {
      print('Error loading user email: $e');
    }
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  /// Forgot password - sends reset link to email
  Future<bool> forgotPassword() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = ForgotPasswordRequest(
        email: emailController.text.trim(),
      );

      final response = await _apiService.forgotPassword(request);

      if (response.success) {
        isLoading.value = false;
        
        Get.snackbar(
          'Success',
          'Password reset link has been sent to your email!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        
        return true;
      } else {
        // Handle error response
        String errorMsg = 'Failed to send reset link. Please try again.';
        
        if (response.error != null) {
          errorMsg = response.error!;
          
          // Try to parse error from response if it's in a specific format
          if (response.error!.contains('errors') || response.error!.contains('error')) {
            errorMsg = 'Failed to send reset link. Please check your email and try again.';
          }
        }
        
        errorMessage.value = errorMsg;
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      isLoading.value = false;
      return false;
    }
  }
}
