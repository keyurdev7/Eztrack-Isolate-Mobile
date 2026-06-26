import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:eztrack_rental/api/api_service.dart';
import 'package:eztrack_rental/theme/color.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateService extends GetxService {
  static UpdateService get to => Get.find();

  final ApiService _apiService = ApiService();
  PackageInfo? _packageInfo;
  
  // Store latest version info
  String? _latestVersion;
  bool? _isForcible;
  bool _isUpdateAvailable = false;

  /// Initialize the service and get package info
  Future<void> initialize() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      print('📦 App Version: ${_packageInfo?.version}');
    } catch (e) {
      print('❌ Error getting package info: $e');
    }
  }

  /// Get current app version
  String getCurrentVersion() {
    return _packageInfo?.version ?? '1.0.0';
  }

  /// Compare two version strings
  /// Returns: -1 if current < latest, 0 if equal, 1 if current > latest
  int compareVersions(String current, String latest) {
    final currentParts = current
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();
    final latestParts = latest
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    // Pad with zeros to ensure same length
    while (currentParts.length < latestParts.length) {
      currentParts.add(0);
    }
    while (latestParts.length < currentParts.length) {
      latestParts.add(0);
    }

    for (int i = 0; i < currentParts.length; i++) {
      if (currentParts[i] < latestParts[i]) {
        return -1;
      } else if (currentParts[i] > latestParts[i]) {
        return 1;
      }
    }
    return 0;
  }

  /// Check for app updates (with optional auto-show dialog)
  Future<void> checkForUpdates(BuildContext? context, {bool showDialog = true}) async {
    try {
      if (_packageInfo == null) {
        await initialize();
      }

      final currentVersion = getCurrentVersion();
      print('🔍 Checking for updates... Current version: $currentVersion');

      final response = await _apiService.checkUpdateStatus();

      if (response.success && response.data != null) {
        final updateData = response.data!.data;
        _latestVersion = updateData.latestVersion;
        _isForcible = updateData.isForcible;

        print('📱 Latest version: $_latestVersion, Forcible: $_isForcible');

        // Compare versions
        final comparison = compareVersions(currentVersion, _latestVersion!);
        _isUpdateAvailable = comparison < 0;

        if (_isUpdateAvailable) {
          // Update available
          print('✅ Update available: $currentVersion -> $_latestVersion');

          // Show dialog if requested and context is available
          if (showDialog) {
            final dialogContext = context ?? Get.context;
            if (dialogContext != null) {
              showUpdateDialog(dialogContext);
            } else {
              print('⚠️ Context not available for showing update dialog');
            }
          }
        } else {
          print('✅ App is up to date');
        }
      } else {
        print('❌ Failed to check for updates: ${response.error}');
        _isUpdateAvailable = false;
      }
    } catch (e) {
      print('❌ Error checking for updates: $e');
      _isUpdateAvailable = false;
    }
  }

  /// Check if update is available (without showing dialog)
  Future<bool> checkUpdateAvailable() async {
    await checkForUpdates(null, showDialog: false);
    return _isUpdateAvailable;
  }

  /// Get latest version string
  String? getLatestVersion() {
    return _latestVersion;
  }

  /// Get if update is forcible
  bool? isForcible() {
    return _isForcible;
  }

  /// Get if update is available
  bool isUpdateAvailable() {
    return _isUpdateAvailable;
  }

  /// Show update dialog (public method)
  void showUpdateDialog(BuildContext context) {
    if (_latestVersion == null || _isForcible == null) {
      print('⚠️ Version info not available. Please check for updates first.');
      return;
    }

    final currentVersion = getCurrentVersion();
    _showUpdateDialog(
      context,
      currentVersion: currentVersion,
      latestVersion: _latestVersion!,
      isForcible: _isForcible!,
    );
  }

  /// Show update dialog (private implementation)
  void _showUpdateDialog(
    BuildContext context, {
    required String currentVersion,
    required String latestVersion,
    required bool isForcible,
  }) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => !isForcible, // Prevent dismissal if forcible
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.system_update, color: primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Update Available',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: mainTextColor,
                    fontFamily: 'BricolageGrotesque',
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A new version of the app is available.',
                style: TextStyle(
                  fontSize: 16,
                  color: mainTextColor,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
              const SizedBox(height: 16),
              _buildVersionRow(
                'Current Version',
                currentVersion,
                mainTextColor,
              ),
              const SizedBox(height: 8),
              _buildVersionRow('Latest Version', latestVersion, primary),
              if (isForcible) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This update is mandatory. Please update to continue using the app.',
                          style: TextStyle(
                            fontSize: 14,
                            color: red,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'BricolageGrotesque',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            if (!isForcible)
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Later',
                  style: TextStyle(
                    color: lightTextColor,
                    fontFamily: 'BricolageGrotesque',
                  ),
                ),
              ),
            if (kDebugMode)
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Later',
                  style: TextStyle(
                    color: lightTextColor,
                    fontFamily: 'BricolageGrotesque',
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                // Open app store or update URL
                // You can customize this to open your app store page
                _openUpdateUrl();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Update Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: !isForcible, // Prevent dismissal if forcible
    );
  }

  Widget _buildVersionRow(String label, String version, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: mainTextColor,
            fontWeight: FontWeight.w500,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        Text(
          version,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w600,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
      ],
    );
  }

  /// Open update URL (App Store, Play Store, etc.)
  void _openUpdateUrl() {
    // TODO: Implement opening app store URL
    // For Android: https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME
    // For iOS: https://apps.apple.com/app/idYOUR_APP_ID
    // You can use url_launcher package which is already in dependencies

    // Get.snackbar(
    //   'Update',
    //   'Please update the app from the App Store or Play Store',
    //   snackPosition: SnackPosition.BOTTOM,
    //   backgroundColor: primary,
    //   colorText: white,
    //   duration: const Duration(seconds: 3),
    // );

    print('📱 Opening update URL...');

    final packageName = _packageInfo?.packageName ?? '';
    final url = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=$packageName'
        : 'https://apps.apple.com/app/idYOUR_APP_ID';
    launchUrl(Uri.parse(url));
  }
}
