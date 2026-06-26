import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/theme/color.dart';
import 'package:eztrack_rental/controllers/login_controller.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? greeting;
  final String? userName;
  final Widget? action;
  final bool showBackButton;

  const CommonAppBar({
    Key? key,
    this.greeting,
    this.userName,
    this.action,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    
    return AppBar(
      backgroundColor: lightBackground,
      elevation: 0,
      leadingWidth: showBackButton ? 70 : 70,
      leading: showBackButton
          ? InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: white,
                  size: 20,
                ),
              ),
            )
          : Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(left: 20),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: primary,
              ),
              child: const Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 32,
              ),
            ),
      title: _buildTitle(loginController),
      actions: action != null ? [action!] : null,
    );
  }

  Widget _buildTitle(LoginController loginController) {
    // If userName is provided, we don't need to observe loginController
    if (userName != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            greeting ?? 'Hello,',
            style: TextStyle(
              fontSize: 14,
              color: lightTextColor,
              fontWeight: FontWeight.w400,
              fontFamily: 'BricolageGrotesque',
            ),
          ),
          Text(
            userName!,
            style: TextStyle(
              fontSize: 20,
              color: appBarTextColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'BricolageGrotesque',
            ),
          ),
        ],
      );
    }
    
    // If userName is not provided, we need to observe loginController.userName
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          greeting ?? 'Hello,',
          style: TextStyle(
            fontSize: 14,
            color: lightTextColor,
            fontWeight: FontWeight.w400,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        Text(
          loginController.userName ?? 'User',
          style: TextStyle(
            fontSize: 20,
            color: appBarTextColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
      ],
    ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}