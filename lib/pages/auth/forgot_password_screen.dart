import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/color.dart';
import '../../constants.dart';
import '../../controllers/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordController controller = Get.put(
      ForgotPasswordController(),
    );

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
                _buildResetPasswordForm(controller),
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
          'Reset Password',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Enter your email to receive reset link',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
      ],
    );
  }

  Widget _buildResetPasswordForm(ForgotPasswordController controller) {
    return Obx(
      () => Form(
        key: controller.formKey,
        child: Column(
          children: [
            // Email Field
            _buildEmailField(controller),
            const SizedBox(height: 20),

            // Error Message
            if (controller.errorMessage.value.isNotEmpty)
              _buildErrorMessage(controller.errorMessage.value),

            const SizedBox(height: 20),

            // Send Reset Link Button
            _buildResetButton(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(ForgotPasswordController controller) {
    return TextFormField(
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => emailValidator(value),
      onChanged: (_) => controller.clearError(),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: 'BricolageGrotesque',
      ),
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'Enter your email address',
        prefixIcon: const Icon(Icons.email_outlined, color: primary),
        filled: true,
        fillColor: primary.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary.withOpacity(0.3), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary.withOpacity(0.3), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
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

  Widget _buildResetButton(ForgotPasswordController controller) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () => _handleResetPassword(controller),
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
                  'Send Reset Link',
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
          'Remember your password? ',
          style: TextStyle(
            color: primary,
            fontSize: 14,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        TextButton(
          onPressed: () => Get.back(),
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

  Future<void> _handleResetPassword(ForgotPasswordController controller) async {
    if (controller.formKey.currentState!.validate()) {
      bool success = await controller.forgotPassword();

      if (success) {
        // Navigate to login screen after successful request
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed('/login');
        });
      }
    }
  }
}
