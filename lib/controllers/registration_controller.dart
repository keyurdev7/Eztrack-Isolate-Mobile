import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/api/api_service.dart';
import 'package:eztrack_rental/api/models/request_models.dart';
import 'package:eztrack_rental/api/models/lookup_models.dart' as lookup;

class RegistrationController extends GetxController {
  final ApiService _apiService = ApiService();
  
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isLoadingCompanies = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Form controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final List<TextEditingController> accessCodeControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> accessCodeFocusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  final List<TextEditingController> verifyAccessCodeControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> verifyAccessCodeFocusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  
  // Company selection
  final RxList<lookup.Company> companies = <lookup.Company>[].obs;
  final Rx<lookup.Company?> selectedCompany = Rx<lookup.Company?>(null);

  @override
  void onInit() {
    super.onInit();
    loadCompanies();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    for (var controller in accessCodeControllers) {
      controller.dispose();
    }
    for (var focusNode in accessCodeFocusNodes) {
      focusNode.dispose();
    }
    for (var controller in verifyAccessCodeControllers) {
      controller.dispose();
    }
    for (var focusNode in verifyAccessCodeFocusNodes) {
      focusNode.dispose();
    }
    super.onClose();
  }

  /// Load companies from API
  Future<void> loadCompanies() async {
    try {
      isLoadingCompanies.value = true;
      final response = await _apiService.getCompanies();
      
      if (response.success && response.data != null) {
        companies.value = response.data!;
      } else {
        errorMessage.value = response.error ?? 'Failed to load companies';
      }
    } catch (e) {
      errorMessage.value = 'Error loading companies: $e';
    } finally {
      isLoadingCompanies.value = false;
    }
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  /// Handle access code input navigation
  void handleAccessCodeInput(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 3) {
        accessCodeFocusNodes[index + 1].requestFocus();
      } else {
        accessCodeFocusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        accessCodeFocusNodes[index - 1].requestFocus();
      }
    }
    clearError();
  }

  /// Handle verify access code input navigation
  void handleVerifyAccessCodeInput(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 3) {
        verifyAccessCodeFocusNodes[index + 1].requestFocus();
      } else {
        verifyAccessCodeFocusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        verifyAccessCodeFocusNodes[index - 1].requestFocus();
      }
    }
    clearError();
  }

  /// Get entered access code
  String getEnteredAccessCode() {
    return accessCodeControllers.map((controller) => controller.text).join();
  }

  /// Get entered verify access code
  String getEnteredVerifyAccessCode() {
    return verifyAccessCodeControllers.map((controller) => controller.text).join();
  }

  /// Validate access code
  String? validateAccessCode() {
    final accessCode = getEnteredAccessCode();
    if (accessCode.length != 4) {
      return 'Please enter a 4-digit code';
    }
    if (!RegExp(r'^\d+$').hasMatch(accessCode)) {
      return 'Access code must be numeric';
    }
    return null;
  }

  /// Validate verify access code
  String? validateVerifyAccessCode() {
    final verifyAccessCode = getEnteredVerifyAccessCode();
    if (verifyAccessCode.length != 4) {
      return 'Please enter a 4-digit verification code';
    }
    if (!RegExp(r'^\d+$').hasMatch(verifyAccessCode)) {
      return 'Verification code must be numeric';
    }
    final accessCode = getEnteredAccessCode();
    if (accessCode != verifyAccessCode) {
      return 'Access codes do not match';
    }
    return null;
  }

  /// Register user
  Future<bool> register() async {
    try {
      // Validate form
      if (!formKey.currentState!.validate()) {
        return false;
      }

      // Validate access code
      final accessCodeError = validateAccessCode();
      if (accessCodeError != null) {
        errorMessage.value = accessCodeError;
        return false;
      }

      // Validate verify access code
      final verifyAccessCodeError = validateVerifyAccessCode();
      if (verifyAccessCodeError != null) {
        errorMessage.value = verifyAccessCodeError;
        return false;
      }

      // Validate company selection
      if (selectedCompany.value == null) {
        errorMessage.value = 'Please select a company';
        return false;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final request = EmployeeSignupRequest(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        company: selectedCompany.value,
        accessCode: getEnteredAccessCode(),
      );

      // final response = await _apiService.employeeSignup(request);
      //
      // if (response.success) {
      //   isLoading.value = false;
      //   return true;
      // } else {
      //   errorMessage.value = response.error ?? 'Registration failed. Please try again.';
      //   isLoading.value = false;
      //   return false;
      // }
      return true;
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      isLoading.value = false;
      return false;
    }
  }
}
