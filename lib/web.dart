// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:eztrack_rental/theme/color.dart';
// import 'package:eztrack_rental/models/login_credentials.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class CustomBrowserScreen extends StatefulWidget {
//   const CustomBrowserScreen({super.key});
//
//   @override
//   State<CustomBrowserScreen> createState() => _CustomBrowserScreenState();
// }
//
// class _CustomBrowserScreenState extends State<CustomBrowserScreen> {
//   late final WebViewController _controller;
//   bool firstLoad = true;
//   LoginCredentials? capturedCredentials;
//   bool autoLoginAttempted = false;
//   bool isOnLoginPage = false;
//   bool isOnDashboard = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkStoredCredentialsAndDecideStartPage();
//     WidgetsBinding.instance.addPostFrameCallback(
//           (_) => _requestPermissions(context),
//     );
//   }
//
//   Future<void> _requestPermissions(BuildContext context) async {
//     // Request Camera Permission
//     PermissionStatus cameraStatus = await Permission.camera.status;
//
//     if (cameraStatus.isDenied) {
//       Permission.camera.request();
//       print("❌ Camera permission denied (ask again next time)");
//     } else if (cameraStatus.isPermanentlyDenied) {
//       print("⚠️ Camera permission permanently denied");
//       _showPermissionDialog(
//         context,
//         title: "Camera Permission Required",
//         description:
//         "This app needs access to the camera for profile images and document upload.",
//       );
//     }
//
//     // Request Photos Permission
//     var photosStatus = await Permission.photos.status;
//
//     if (photosStatus.isDenied) {
//       Permission.photos.request();
//       print("❌ Photos permission denied (ask again next time)");
//     } else if (photosStatus.isPermanentlyDenied) {
//       print("⚠️ Photos permission permanently denied");
//       _showPermissionDialog(
//         context,
//         title: "Photos Permission Required",
//         description:
//         "This app requires photo library access for profile images and document upload.",
//       );
//     }
//   }
//
//   void _showPermissionDialog(
//       BuildContext context, {
//         required String title,
//         required String description,
//       }) {
//     showCupertinoDialog(
//       barrierDismissible: true,
//       context: context,
//       builder: (_) => CupertinoAlertDialog(
//         title: Text(title),
//         content: Text(description),
//         actions: [
//           CupertinoDialogAction(
//             isDefaultAction: true,
//             child: const Text("Continue"),
//             onPressed: () {
//               Navigator.of(context).pop();
//               openAppSettings(); // Redirect to iOS settings
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _checkStoredCredentialsAndDecideStartPage() async {
//     final storedCreds = await getLastStoredCredentials();
//
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..addJavaScriptChannel(
//         'FlutterChannel',
//         onMessageReceived: (JavaScriptMessage message) {
//           _handleCredentials(message.message);
//         },
//       )
//       ..addJavaScriptChannel(
//         'LogoutChannel',
//         onMessageReceived: (JavaScriptMessage message) {
//           _handleLogout();
//         },
//       )
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (url) {
//             _updatePageState(url, context);
//
//             if (firstLoad) {
//               setState(() {
//                 firstLoad = true; // still loading
//               });
//             }
//           },
//           onPageFinished: (url) {
//             // Hide loader only once after first load
//             if (firstLoad) {
//               setState(() {
//                 firstLoad = false;
//               });
//             }
//
//             _updatePageState(url, context);
//             _handlePageFinished(url);
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             // Allow all navigation
//             return NavigationDecision.navigate;
//           },
//         ),
//       );
//
//     // Decide which page to load initially
//     if (storedCreds != null) {
//       // If we have stored credentials, try to go directly to dashboard
//       print(
//         '📱 Found stored credentials for ${storedCreds.email}, attempting direct dashboard access...',
//       );
//       await _controller.loadRequest(
//         Uri.parse("https://ilaservice.com/struct/dashboard"),
//       );
//     } else {
//       // No stored credentials, go to login page
//       print('📱 No stored credentials found, redirecting to login page...');
//       await _controller.loadRequest(
//         Uri.parse("https://ilaservice.com/struct/login"),
//       );
//     }
//   }
//
//   void _handleCredentials(String message) {
//     try {
//       final Map<String, dynamic> data = jsonDecode(message);
//       final credentials = LoginCredentials(
//         email: data['email'] ?? '',
//         password: data['password'] ?? '',
//         timestamp: DateTime.now(),
//       );
//
//       setState(() {
//         capturedCredentials = credentials;
//       });
//
//       // Print for debugging (remove in production)
//       print('Captured credentials: ${credentials.toString()}');
//
//       // You can also store this in shared preferences, database, or send to server
//       _storeCredentials(credentials);
//     } catch (e) {
//       print('Error parsing credentials: $e');
//     }
//   }
//
//   void _updatePageState(String url, BuildContext context) {
//     setState(() {
//       isOnLoginPage = url.contains('/login');
//       isOnDashboard = url.contains('/dashboard');
//     });
//
//     if (url.contains("/account") && (Platform.isIOS || Platform.isMacOS)) {
//       _requestPermissions(context);
//     } else if (url.contains("/account/profile-image") &&
//         (Platform.isIOS || Platform.isMacOS)) {
//       _requestPermissions(context);
//     }
//     print(
//       '📍 Page state updated: login=$isOnLoginPage, dashboard=$isOnDashboard, URL=$url',
//     );
//   }
//
//   Future<void> _handlePageFinished(String url) async {
//     if (isOnLoginPage && !autoLoginAttempted) {
//       // We're on login page and haven't attempted auto-login yet
//       final storedCreds = await getLastStoredCredentials();
//       if (storedCreds != null) {
//         print('🔄 Attempting auto-login with stored credentials...');
//         await _performAutoLogin(storedCreds);
//       } else {
//         // Inject form capture script for manual login
//         _injectFormCaptureScript();
//       }
//     } else if (isOnLoginPage && autoLoginAttempted) {
//       // Auto-login failed or user was redirected back to login
//       print('❌ Auto-login failed or session expired, showing login form...');
//       _injectFormCaptureScript();
//     } else if (isOnDashboard) {
//       // Successfully on dashboard
//       print('✅ Successfully reached dashboard!');
//       _injectLogoutDetectionScript();
//     } else {
//       // Other pages, inject form capture script just in case
//       _injectFormCaptureScript();
//     }
//   }
//
//   Future<void> _performAutoLogin(LoginCredentials credentials) async {
//     autoLoginAttempted = true;
//
//     final script =
//     '''
//       (function() {
//         // Find email and password inputs
//         const emailInputs = document.querySelectorAll('input[type="email"], input[name*="email"], input[id*="email"], input[placeholder*="email"]');
//         const passwordInputs = document.querySelectorAll('input[type="password"], input[name*="password"], input[id*="password"]');
//
//         if (emailInputs.length > 0 && passwordInputs.length > 0) {
//           // Fill the form
//           emailInputs[0].value = "${credentials.email}";
//           emailInputs[0].dispatchEvent(new Event('input', { bubbles: true }));
//
//           passwordInputs[0].value = "${credentials.password}";
//           passwordInputs[0].dispatchEvent(new Event('input', { bubbles: true }));
//
//           // Try to find and click submit button
//           const submitButtons = document.querySelectorAll('button[type="submit"], input[type="submit"], button:contains("Sign in"), button:contains("Login")');
//           if (submitButtons.length > 0) {
//             // Small delay to ensure form is properly filled
//             setTimeout(() => {
//               submitButtons[0].click();
//               console.log('🚀 Auto-login form submitted');
//             }, 500);
//           } else {
//             // Try to find any button that might be the submit button
//             const allButtons = document.querySelectorAll('button');
//             for (let button of allButtons) {
//               if (button.textContent.toLowerCase().includes('sign') ||
//                   button.textContent.toLowerCase().includes('login')) {
//                 setTimeout(() => {
//                   button.click();
//                   console.log('🚀 Auto-login form submitted via button search');
//                 }, 500);
//                 break;
//               }
//             }
//           }
//
//           // Also try form submission
//           const forms = document.querySelectorAll('form');
//           if (forms.length > 0) {
//             setTimeout(() => {
//               forms[0].submit();
//               console.log('🚀 Auto-login form submitted via form.submit()');
//             }, 1000);
//           }
//         } else {
//           console.log('❌ Could not find email/password fields for auto-login');
//         }
//       })();
//     ''';
//
//     await _controller.runJavaScript(script);
//
//     // Check after a delay if we successfully reached dashboard
//     Future.delayed(const Duration(seconds: 3), () async {
//       final currentUrl = await _controller.currentUrl();
//       if (currentUrl != null && currentUrl.contains('/dashboard')) {}
//     });
//   }
//
//   void _handleLogout() {
//     print('🚪 Logout detected, clearing stored credentials...');
//     clearStoredCredentials();
//     setState(() {
//       capturedCredentials = null;
//       autoLoginAttempted = false;
//     });
//   }
//
//   void _injectLogoutDetectionScript() {
//     const String script = '''
//       (function() {
//         // Look for logout buttons/links
//         const logoutElements = document.querySelectorAll('a, button');
//
//         logoutElements.forEach(element => {
//           const text = element.textContent.toLowerCase();
//           if (text.includes('logout') || text.includes('sign out') || text.includes('log out')) {
//             element.addEventListener('click', function() {
//               LogoutChannel.postMessage('logout_clicked');
//             });
//           }
//         });
//
//         // Also monitor URL changes that might indicate logout
//         const originalPushState = history.pushState;
//         const originalReplaceState = history.replaceState;
//
//         history.pushState = function() {
//           originalPushState.apply(history, arguments);
//           checkForLogout();
//         };
//
//         history.replaceState = function() {
//           originalReplaceState.apply(history, arguments);
//           checkForLogout();
//         };
//
//         window.addEventListener('popstate', checkForLogout);
//
//         function checkForLogout() {
//           if (window.location.href.includes('/login') ||
//               window.location.href.includes('/logout')) {
//             LogoutChannel.postMessage('logout_detected');
//           }
//         }
//
//         console.log('🔍 Logout detection script injected');
//       })();
//     ''';
//
//     _controller.runJavaScript(script);
//   }
//
//   Future<void> _storeCredentials(LoginCredentials credentials) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//
//       // Store individual fields
//       await prefs.setString('login_email', credentials.email);
//       await prefs.setString('login_password', credentials.password);
//       await prefs.setString(
//         'login_timestamp',
//         credentials.timestamp.toIso8601String(),
//       );
//
//       // Store complete credentials as JSON for easy retrieval
//       final credentialsJson = jsonEncode(credentials.toJson());
//       await prefs.setString('login_credentials', credentialsJson);
//
//       // Store login history (keep last 5 logins)
//       final loginHistory = prefs.getStringList('login_history') ?? [];
//       loginHistory.insert(0, credentialsJson);
//
//       // Keep only last 5 entries
//       if (loginHistory.length > 5) {
//         loginHistory.removeRange(5, loginHistory.length);
//       }
//
//       await prefs.setStringList('login_history', loginHistory);
//
//       print(
//         '✅ Credentials stored successfully for email: ${credentials.email}',
//       );
//     } catch (e) {
//       print('❌ Error storing credentials: $e');
//     }
//   }
//
//   // Method to retrieve the last stored credentials
//   Future<LoginCredentials?> getLastStoredCredentials() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final credentialsJson = prefs.getString('login_credentials');
//
//       if (credentialsJson != null) {
//         final Map<String, dynamic> data = jsonDecode(credentialsJson);
//         return LoginCredentials.fromJson(data);
//       }
//
//       return null;
//     } catch (e) {
//       print('Error retrieving credentials: $e');
//       return null;
//     }
//   }
//
//   // Method to retrieve login history
//   Future<List<LoginCredentials>> getLoginHistory() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final loginHistory = prefs.getStringList('login_history') ?? [];
//
//       return loginHistory
//           .map((json) => LoginCredentials.fromJson(jsonDecode(json)))
//           .toList();
//     } catch (e) {
//       print('Error retrieving login history: $e');
//       return [];
//     }
//   }
//
//   // Method to clear stored credentials
//   Future<void> clearStoredCredentials() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('login_email');
//       await prefs.remove('login_password');
//       await prefs.remove('login_timestamp');
//       await prefs.remove('login_credentials');
//       await prefs.remove('login_history');
//
//       print('✅ All stored credentials cleared');
//
//       // if (mounted) {
//       //   ScaffoldMessenger.of(context).showSnackBar(
//       //     const SnackBar(
//       //       content: Text('All stored credentials cleared'),
//       //       backgroundColor: Colors.orange,
//       //       duration: Duration(seconds: 2),
//       //     ),
//       //   );
//       // }
//     } catch (e) {
//       print('❌ Error clearing credentials: $e');
//     }
//   }
//
//   // Method to check if there are stored credentials
//   Future<bool> hasStoredCredentials() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.containsKey('login_credentials');
//     } catch (e) {
//       print('Error checking stored credentials: $e');
//       return false;
//     }
//   }
//
//   void _injectFormCaptureScript() {
//     const String script = '''
//       (function() {
//         function captureFormData() {
//           // Look for common email input selectors
//           const emailInputs = document.querySelectorAll('input[type="email"], input[name*="email"], input[id*="email"], input[placeholder*="email"]');
//           // Look for common password input selectors
//           const passwordInputs = document.querySelectorAll('input[type="password"], input[name*="password"], input[id*="password"]');
//
//           let email = '';
//           let password = '';
//
//           if (emailInputs.length > 0) {
//             email = emailInputs[0].value;
//           }
//
//           if (passwordInputs.length > 0) {
//             password = passwordInputs[0].value;
//           }
//
//           if (email && password) {
//             const data = {
//               email: email,
//               password: password
//             };
//             FlutterChannel.postMessage(JSON.stringify(data));
//           }
//         }
//
//         // Capture on form submission
//         const forms = document.querySelectorAll('form');
//         forms.forEach(form => {
//           form.addEventListener('submit', function(e) {
//             captureFormData();
//           });
//         });
//
//         // Also capture on button clicks (in case form submission is handled differently)
//         const buttons = document.querySelectorAll('button[type="submit"], input[type="submit"], button');
//         buttons.forEach(button => {
//           button.addEventListener('click', function(e) {
//             setTimeout(captureFormData, 100); // Small delay to ensure values are captured
//           });
//         });
//
//         // Capture on Enter key press in password field
//         const passwordInputs = document.querySelectorAll('input[type="password"]');
//         passwordInputs.forEach(input => {
//           input.addEventListener('keypress', function(e) {
//             if (e.key === 'Enter') {
//               setTimeout(captureFormData, 100);
//             }
//           });
//         });
//       })();
//     ''';
//
//     _controller.runJavaScript(script);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           if (!firstLoad)
//             SafeArea(child: WebViewWidget(controller: _controller)),
//           if (firstLoad)
//             const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(primary),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
