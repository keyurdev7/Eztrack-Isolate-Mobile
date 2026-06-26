import 'package:eztrack_rental/pages/login_screen.dart';
import 'package:eztrack_rental/pages/main_screen.dart';
import 'package:eztrack_rental/pages/manage_login_screen.dart';
import 'package:eztrack_rental/pages/registration_screen.dart';
import 'package:eztrack_rental/pages/auth/forgot_password_screen.dart';
import 'package:eztrack_rental/pages/projects_list_screen.dart';
import 'package:eztrack_rental/controllers/login_controller.dart';

import 'package:eztrack_rental/utils/preference_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/services/fcm_service.dart';
import 'package:eztrack_rental/services/update_service.dart';
import 'package:eztrack_rental/controllers/dropdown_controller.dart';
import 'package:eztrack_rental/controllers/filter_controller.dart';
import 'package:eztrack_rental/controllers/isolate_controller.dart';

import 'firebase_options.dart';

import 'theme/color.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform
  // );

  // Initialize SharedPreferences
  await PreferenceManager.init();

  // Initialize FCM Service
  // Get.put(FCMService());

  // Initialize Update Service
  final updateService = Get.put(UpdateService());
  await updateService.initialize();

  // Initialize Dropdown Controller (loads all dropdown data on app start)
  Get.put(DropdownController());

  // Initialize Filter Controller
  Get.put(FilterController());

  // Register LoginController permanently so it survives route changes
  Get.put(LoginController(), permanent: true);
  Get.put(IsolateController(), permanent: true);

  // Set up background message handler
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eztrak Isolate',
      theme: ThemeData(
        primaryColor: primary,
        scaffoldBackgroundColor: lightBackground,
        textTheme: Theme.of(
          context,
        ).textTheme.apply(fontFamily: 'BricolageGrotesque'),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: mainTextColor),
          titleTextStyle: TextStyle(
            color: mainTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
      ),
      // Define routes
      getPages: [
        // GetPage(name: '/welcome', page: () => const WelcomeScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/manage-login', page: () => const ManageLoginScreen()),
        GetPage(name: '/register', page: () => const RegistrationScreen()),
        GetPage(
          name: '/forgot-password',
          page: () => const ForgotPasswordScreen(),
        ),
        GetPage(name: '/projects', page: () => const ProjectsListScreen()),
        GetPage(name: '/main', page: () => const MainScreen()),
      ],
      // home: const AppInitializer
      home: const AppInitializer(),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _checkCredentialsAndNavigate();
  }

  Future<void> _checkCredentialsAndNavigate() async {
    try {
      // Check if user is logged in
      bool isLoggedIn = await PreferenceManager.isLoggedIn();
      bool isFirstTime = await PreferenceManager.isFirstTime();

      // Add a small delay to show splash/loading effect
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        if (isLoggedIn) {
          // User is logged in, navigate to projects list screen
          print('📱 User is logged in, navigating to projects list screen...');
          // Get.offAllNamed('/projects');
          Get.offAllNamed('/main');
        } else if (isFirstTime) {
          // First time user, navigate to welcome screen
          print('📱 First time user, navigating to welcome screen...');
          //  Get.offAllNamed('/welcome');
          Get.offAllNamed('/login');
        } else {
          // Returning user but not logged in, navigate to welcome screen
          print(
            '📱 Returning user but not logged in, navigating to welcome screen...',
          );
          // Get.offAllNamed('/welcome');
          Get.offAllNamed('/login');
        }

        // Check for app updates after navigation (using post-frame callback to ensure context is ready)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            UpdateService.to.checkForUpdates(Get.context);
          } catch (e) {
            print('❌ Error checking for updates: $e');
          }
        });
      }
    } catch (e) {
      print('❌ Error checking login state: $e');
      // On error, default to welcome screen
      if (mounted) {
        Get.offAllNamed('/login');
        // Get.offAllNamed('/welcome');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: primary),
            const SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                color: mainTextColor,
                fontFamily: 'BricolageGrotesque',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
