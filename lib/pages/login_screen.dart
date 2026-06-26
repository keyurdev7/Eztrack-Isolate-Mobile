import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/theme/color.dart';
import 'package:eztrack_rental/controllers/login_controller.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const Spacer(flex: 2),
                const SizedBox(height: 40),
                _buildLogo(),
                const SizedBox(height: 50),
                _buildCodeInputFields(controller),
                const SizedBox(height: 20),
                Obx(
                  () => controller.errorMessage.value.isNotEmpty
                      ? _buildErrorMessage(controller.errorMessage.value)
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 20),
                _buildLoginButton(controller),
                const SizedBox(height: 20),
                _buildForgotPasswordLink(),

                // _buildBackToWelcomeButton(controller),
                // const Spacer(flex: 3),
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
        // Red arc logo
        _buildHeader(),
        const SizedBox(height: 16),
        // Company name
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
        const Text(
          'Login with pincode',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      // width: 300,
      height: 70,
      margin: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        // shape: BoxShape.circle,
        // color: primary,
        image: const DecorationImage(
          image: AssetImage('assets/images/logo.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildCodeInputFields(LoginController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
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
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => controller.handlePinInput(index, value),
            onTap: () => controller.clearError(),
          ),
        );
      }),
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

  Widget _buildLoginButton(LoginController controller) {
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
          onPressed: () => Get.toNamed('/register'),
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

  Widget _buildBackToWelcomeButton(LoginController controller) {
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
    return TextButton(
      onPressed: () => controller.navigateToWelcomeScreen(),
      child: const Text(
        'Back to Welcome',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontFamily: 'BricolageGrotesque',
        ),
      ),
    );
  }

  Future<void> _handleLogin(LoginController controller) async {
    // Validate pincode
    if (!controller.validatePincode()) {
      controller.errorMessage.value = 'Please enter a 4-digit code';
      return;
    }

    // Get device ID
    String deviceId = await _getDeviceId();

    // Get entered pincode
    String pincode = controller.getEnteredPincode();

    // Attempt login
    bool success = await controller.loginWithPincode(pincode, deviceId);

    if (success) {
      controller.navigateToMainScreen();
    } else {
      // Clear the input fields
      for (var pinController in controller.pinControllers) {
        pinController.clear();
      }
      controller.focusNodes[0].requestFocus();
      // controller.navigateToMainScreen();
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
