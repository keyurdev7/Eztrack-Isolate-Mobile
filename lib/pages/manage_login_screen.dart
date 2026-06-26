import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/theme/color.dart';
import 'package:eztrack_rental/controllers/manage_login_controller.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class ManageLoginScreen extends StatelessWidget {
  const ManageLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Get.find() if controller exists, otherwise create it
    final ManageLoginController controller =
        Get.isRegistered<ManageLoginController>()
        ? Get.find<ManageLoginController>()
        : Get.put(ManageLoginController(), permanent: false);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                const SizedBox(height: 40),
                _buildLogo(),
                const SizedBox(height: 30),
                _buildLoginModeToggle(controller),
                const SizedBox(height: 30),
                Obx(
                  () => controller.isEmailPasswordMode.value
                      ? _buildEmailPasswordForm(controller)
                      : _buildAccessCodeForm(controller),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => controller.errorMessage.value.isNotEmpty
                      ? _buildErrorMessage(controller.errorMessage.value)
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 20),
                _buildLoginButton(controller),
                const SizedBox(height: 20),
                Obx(
                  () => controller.isEmailPasswordMode.value
                      ? _buildForgotPasswordLink()
                      : const SizedBox.shrink(),
                ),
                _buildRegisterLink(),
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
        _buildHeader(),
        const SizedBox(height: 16),
        const Text(
          'Login',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        const SizedBox(height: 4),
        Obx(() {
          final controller = Get.find<ManageLoginController>();
          return Text(
            controller.isEmailPasswordMode.value
                ? 'Login with Email and Password'
                : 'Login with Access Code',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: 'BricolageGrotesque',
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/logo.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildLoginModeToggle(ManageLoginController controller) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => GestureDetector(
                onTap: () {
                  if (!controller.isEmailPasswordMode.value) {
                    controller.toggleLoginMode();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: controller.isEmailPasswordMode.value
                        ? primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Email & Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: controller.isEmailPasswordMode.value
                          ? Colors.white
                          : primary,
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => GestureDetector(
                onTap: () {
                  if (controller.isEmailPasswordMode.value) {
                    controller.toggleLoginMode();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: !controller.isEmailPasswordMode.value
                        ? primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Access Code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: !controller.isEmailPasswordMode.value
                          ? Colors.white
                          : primary,
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailPasswordForm(ManageLoginController controller) {
    return Column(
      children: [
        _buildEmailField(controller),
        const SizedBox(height: 20),
        _buildPasswordField(controller),
      ],
    );
  }

  Widget _buildEmailField(ManageLoginController controller) {
    try {
      // Check if controller is still registered before accessing it
      if (!Get.isRegistered<ManageLoginController>()) {
        return const SizedBox.shrink();
      }
      return TextFormField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'Enter your email',
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
          labelStyle: const TextStyle(
            color: primary,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        onChanged: (_) {
          try {
            controller.clearError();
          } catch (e) {
            // Controller might be disposed, ignore
          }
        },
      );
    } catch (e) {
      // If controller is disposed, return empty widget
      return const SizedBox.shrink();
    }
  }

  Widget _buildPasswordField(ManageLoginController controller) {
    return Obx(() {
      try {
        // Check if controller is still registered before accessing it
        if (!Get.isRegistered<ManageLoginController>()) {
          return const SizedBox.shrink();
        }
        // Safely access the controller's obscurePassword value
        final obscureText = controller.obscurePassword.value;
        return TextFormField(
          controller: controller.passwordController,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: const Icon(Icons.lock_outlined, color: primary),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: primary,
              ),
              onPressed: () {
                try {
                  controller.togglePasswordVisibility();
                } catch (e) {
                  // Controller might be disposed, ignore
                }
              },
            ),
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
            labelStyle: const TextStyle(
              color: primary,
              fontFamily: 'BricolageGrotesque',
            ),
          ),
          onChanged: (_) {
            try {
              controller.clearError();
            } catch (e) {
              // Controller might be disposed, ignore
            }
          },
        );
      } catch (e) {
        // If controller is disposed, return empty widget
        return const SizedBox.shrink();
      }
    });
  }

  Widget _buildAccessCodeForm(ManageLoginController controller) {
    try {
      // Check if controller is still registered before accessing it
      if (!Get.isRegistered<ManageLoginController>()) {
        return const SizedBox.shrink();
      }
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              try {
                return Container(
                  margin: EdgeInsets.only(right: index < 3 ? 16 : 0),
                  width: 60,
                  height: 60,
                  child: TextFormField(
                    obscureText: true,
                    controller: controller.pinControllers[index],
                    focusNode: controller.focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primary,
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
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      try {
                        controller.handlePinInput(index, value);
                      } catch (e) {
                        // Controller might be disposed, ignore
                      }
                    },
                    onTap: () {
                      try {
                        controller.clearError();
                      } catch (e) {
                        // Controller might be disposed, ignore
                      }
                    },
                  ),
                );
              } catch (e) {
                // If controller is disposed, return empty container
                return const SizedBox.shrink();
              }
            }),
          ),
        ],
      );
    } catch (e) {
      // If controller is disposed, return empty widget
      return const SizedBox.shrink();
    }
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

  Widget _buildLoginButton(ManageLoginController controller) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () => _handleLogin(controller),
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
                  'Login',
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

  Widget _buildForgotPasswordLink() {
    return TextButton(
      onPressed: () => Get.toNamed('/forgot-password'),
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          color: primary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'BricolageGrotesque',
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(
            color: primary,
            fontSize: 14,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        TextButton(
          onPressed: () {
            Get.toNamed('/register');
          },
          child: const Text(
            'Register',
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

  Future<void> _handleLogin(ManageLoginController controller) async {
    if (controller.isEmailPasswordMode.value) {
      // Email and Password login
      final email = controller.emailController.text.trim();
      final password = controller.passwordController.text;

      // Validate email
      if (!controller.validateEmail(email)) {
        controller.errorMessage.value = 'Please enter a valid email address';
        return;
      }

      // Validate password
      if (!controller.validatePassword(password)) {
        controller.errorMessage.value = 'Password is required';
        return;
      }

      // Attempt login
      bool success = await controller.loginWithEmailPassword(email, password);

      if (success) {
        controller.navigateToMainScreen();
      } else {
        // Clear password field on error
        controller.passwordController.clear();
      }
    } else {
      // Access Code login
      if (!controller.validateAccessCode()) {
        controller.errorMessage.value = 'Please enter a 4-digit access code';
        return;
      }

      // Get device ID
      String deviceId = await _getDeviceId();

      // Get entered access code
      String accessCode = controller.getEnteredAccessCode();

      // Attempt login
      bool success = await controller.loginWithAccessCode(accessCode, deviceId);

      if (success) {
        controller.navigateToMainScreen();
      } else {
        // Clear the input fields
        for (var pinController in controller.pinControllers) {
          pinController.clear();
        }
        controller.focusNodes[0].requestFocus();
      }
    }
  }

  Future<String> _getDeviceId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'ios_device';
      } else {
        return 'unknown_device';
      }
    } catch (e) {
      return 'device_error';
    }
  }
}
