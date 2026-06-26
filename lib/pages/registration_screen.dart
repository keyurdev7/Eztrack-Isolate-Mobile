import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/theme/color.dart';
import 'package:eztrack_rental/controllers/registration_controller.dart';
import 'package:eztrack_rental/constants.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegistrationController controller = Get.put(RegistrationController());

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     red,
          //     primary,
          //   ],
          // ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                _buildLogo(),
                const SizedBox(height: 40),
                _buildRegistrationForm(controller),
                const SizedBox(height: 20),
                _buildLoginLink(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          height: 70,
          margin: const EdgeInsets.only(left: 20),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Sign up to get started',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm(RegistrationController controller) {
    return Obx(
      () => Form(
        key: controller.formKey,
        child: Column(
          children: [
            // Full Name
            _buildTextField(
              controller: controller.fullNameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person_outline,
              validator: requiredValidator,
            ),
            const SizedBox(height: 16),

            // Email
            _buildTextField(
              controller: controller.emailController,
              label: 'Email',
              hint: 'Enter your email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: emailValidator,
            ),
            const SizedBox(height: 16),

            // Company Dropdown
            _buildCompanyDropdown(controller),
            const SizedBox(height: 16),

            // Access Code (4-digit PIN)
            _buildAccessCodeFields(controller),
            const SizedBox(height: 16),

            // Verify Access Code (4-digit PIN)
            _buildVerifyAccessCodeFields(controller),
            const SizedBox(height: 20),

            // Error Message
            if (controller.errorMessage.value.isNotEmpty)
              _buildErrorMessage(controller.errorMessage.value),

            const SizedBox(height: 20),

            // Register Button
            _buildRegisterButton(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 16,
        fontFamily: 'BricolageGrotesque',
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: primary),
        filled: true,
        // fillColor: Colors.white60,
        fillColor: primary.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary.withOpacity(0.3), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: const TextStyle(
          color: primary,
          fontFamily: 'BricolageGrotesque',
        ),
        hintStyle: TextStyle(
          color: primary.withOpacity(0.5),
          fontFamily: 'BricolageGrotesque',
        ),
      ),
    );
  }

  Widget _buildCompanyDropdown(RegistrationController controller) {
    return Obx(() {
      if (controller.isLoadingCompanies.value) {
        return Container(
          height: 60,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primary.withOpacity(0.3), width: 2),
          ),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
        );
      }

      return DropdownButtonFormField<dynamic>(
        value: controller.selectedCompany.value,
        decoration: InputDecoration(
          labelText: 'Company',
          hintText: 'Select your company',
          prefixIcon: const Icon(Icons.business_outlined, color: primary),
          filled: true,
          // fillColor: Colors.white,
          fillColor: primary.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primary.withOpacity(0.3), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          labelStyle: const TextStyle(
            color: primary,
            fontFamily: 'BricolageGrotesque',
          ),
          hintStyle: TextStyle(
            color: primary,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        dropdownColor: Colors.white,
        // dropdownColor: primary.withOpacity(0.1),
        style: const TextStyle(
          color: primary,
          fontSize: 16,
          fontFamily: 'BricolageGrotesque',
        ),
        icon: const Icon(Icons.arrow_drop_down, color: primary),
        items: controller.companies.map((company) {
          return DropdownMenuItem<dynamic>(
            value: company,
            child: Text(
              company.name ?? '',
              style: const TextStyle(
                color: Colors.black87,
                fontFamily: 'BricolageGrotesque',
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          controller.selectedCompany.value = value;
          controller.clearError();
        },
        validator: (value) {
          if (value == null) {
            return 'Please select a company';
          }
          return null;
        },
      );
    });
  }

  Widget _buildAccessCodeFields(RegistrationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Access Code (4-digit PIN)',
            style: TextStyle(
              color: primary,
              fontSize: 14,
              fontFamily: 'BricolageGrotesque',
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              margin: EdgeInsets.only(right: index < 3 ? 16 : 0),
              width: 60,
              height: 60,
              child: Center(
                child: TextFormField(
                  controller: controller.accessCodeControllers[index],
                  focusNode: controller.accessCodeFocusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,

                  maxLength: 1,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'BricolageGrotesque',
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,

                    fillColor: primary.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: primary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: primary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: primary, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) =>
                      controller.handleAccessCodeInput(index, value),
                  onTap: () => controller.clearError(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildVerifyAccessCodeFields(RegistrationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Verify Access Code (4-digit PIN)',
            style: TextStyle(
              color: primary,
              fontSize: 14,
              fontFamily: 'BricolageGrotesque',
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              margin: EdgeInsets.only(right: index < 3 ? 16 : 0),
              width: 60,
              height: 60,
              child: Center(
                child: TextFormField(
                  controller: controller.verifyAccessCodeControllers[index],
                  focusNode: controller.verifyAccessCodeFocusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,

                  maxLength: 1,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'BricolageGrotesque',
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,

                    fillColor: primary.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: primary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: primary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: primary, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) =>
                      controller.handleVerifyAccessCodeInput(index, value),
                  onTap: () => controller.clearError(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 14,

          fontFamily: 'BricolageGrotesque',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRegisterButton(RegistrationController controller) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () => _handleRegistration(controller),
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'BricolageGrotesque',
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(
            color: primary,
            fontSize: 14,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        TextButton(
          onPressed: () => Get.offNamed('/login'),
          child: const Text(
            'Login',
            style: TextStyle(
              color: primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'BricolageGrotesque',
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleRegistration(RegistrationController controller) async {
    if (controller.formKey.currentState!.validate()) {
      // Validate access code
      final accessCodeError = controller.validateAccessCode();
      if (accessCodeError != null) {
        controller.errorMessage.value = accessCodeError;
        return;
      }

      // Validate verify access code
      final verifyAccessCodeError = controller.validateVerifyAccessCode();
      if (verifyAccessCodeError != null) {
        controller.errorMessage.value = verifyAccessCodeError;
        return;
      }

      bool success = await controller.register();

      if (success) {
        Get.snackbar(
          'Success',
          'Registration successful! Please login.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        // Navigate to login screen after successful registration
        Future.delayed(const Duration(seconds: 2), () {
          Get.offNamed('/login');
        });
      }
    }
  }
}
