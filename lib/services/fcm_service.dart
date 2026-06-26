// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class FCMService extends GetxService {
//   static FCMService get to => Get.find();
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
//
//   // Observable variables
//   final RxString fcmToken = ''.obs;
//   final RxBool isInitialized = false.obs;
//   final RxBool hasPermission = false.obs;
//
//   // Notification channel for Android
//   static const String _channelId = 'eztrack_notifications';
//   static const String _channelName = 'EZTrack Notifications';
//   static const String _channelDescription = 'Notifications for EZTrack app';
//
//   @override
//   Future<void> onInit() async {
//     super.onInit();
//     await initializeFCM();
//   }
//
//   /// Initialize Firebase Cloud Messaging
//   Future<void> initializeFCM() async {
//     try {
//       print('🔔 FCM Service - Initializing FCM...');
//
//       // Initialize Firebase if not already initialized
//       if (Firebase.apps.isEmpty) {
//         await Firebase.initializeApp();
//       }
//
//       // Request notification permissions
//       await requestNotificationPermissions();
//
//       // Initialize local notifications
//       await initializeLocalNotifications();
//
//       // Get FCM token
//       await getFCMToken();
//
//       // Configure message handlers
//       configureMessageHandlers();
//
//       isInitialized.value = true;
//       print('✅ FCM Service - Initialization completed');
//
//     } catch (e) {
//       print('❌ FCM Service - Initialization failed: $e');
//     }
//   }
//
//   /// Request notification permissions
//   Future<void> requestNotificationPermissions() async {
//     try {
//       print('🔔 FCM Service - Requesting notification permissions...');
//
//       // Request permission for notifications
//       NotificationSettings settings = await _firebaseMessaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );
//
//       hasPermission.value = settings.authorizationStatus == AuthorizationStatus.authorized;
//
//       if (hasPermission.value) {
//         print('✅ FCM Service - Notification permissions granted');
//       } else {
//         print('⚠️ FCM Service - Notification permissions denied');
//       }
//
//       // For Android 13+, also request POST_NOTIFICATIONS permission
//       if (Platform.isAndroid) {
//         final androidInfo = await DeviceInfoPlugin().androidInfo;
//         if (androidInfo.version.sdkInt >= 33) {
//           final status = await Permission.notification.request();
//           if (status.isGranted) {
//             print('✅ FCM Service - Android 13+ notification permission granted');
//           } else {
//             print('⚠️ FCM Service - Android 13+ notification permission denied');
//           }
//         }
//       }
//
//     } catch (e) {
//       print('❌ FCM Service - Permission request failed: $e');
//     }
//   }
//
//   /// Initialize local notifications
//   Future<void> initializeLocalNotifications() async {
//     try {
//       print('🔔 FCM Service - Initializing local notifications...');
//
//       // Android initialization settings
//       const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//
//       // iOS initialization settings
//       const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//       );
//
//       // Combined initialization settings
//       const InitializationSettings initSettings = InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       );
//
//       // Initialize the plugin
//       await _localNotifications.initialize(
//         initSettings,
//         onDidReceiveNotificationResponse: onNotificationTapped,
//       );
//
//       // Create notification channel for Android
//       if (Platform.isAndroid) {
//         await createNotificationChannel();
//       }
//
//       print('✅ FCM Service - Local notifications initialized');
//
//     } catch (e) {
//       print('❌ FCM Service - Local notifications initialization failed: $e');
//     }
//   }
//
//   /// Create notification channel for Android
//   Future<void> createNotificationChannel() async {
//     try {
//       const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         _channelId,
//         _channelName,
//         description: _channelDescription,
//         importance: Importance.high,
//         playSound: true,
//         enableVibration: true,
//         showBadge: true,
//       );
//
//       await _localNotifications
//           .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);
//
//       print('✅ FCM Service - Notification channel created');
//
//     } catch (e) {
//       print('❌ FCM Service - Notification channel creation failed: $e');
//     }
//   }
//
//   /// Get FCM token
//   Future<String?> getFCMToken() async {
//     try {
//       print('🔔 FCM Service - Getting FCM token...');
//
//       String? token = await _firebaseMessaging.getToken();
//
//       if (token != null) {
//         fcmToken.value = token;
//         await saveFCMTokenToStorage(token);
//         print('✅ FCM Token ${fcmToken.value}');
//         print('✅ FCM Service - FCM token obtained: ${token.substring(0, 20)}...');
//         return token;
//       } else {
//         print('⚠️ FCM Service - FCM token is null');
//         return null;
//       }
//
//     } catch (e) {
//       print('❌ FCM Service - Failed to get FCM token: $e');
//       return null;
//     }
//   }
//
//   /// Save FCM token to local storage
//   Future<void> saveFCMTokenToStorage(String token) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('fcm_token', token);
//       print('✅ FCM Service - FCM token saved to storage');
//     } catch (e) {
//       print('❌ FCM Service - Failed to save FCM token: $e');
//     }
//   }
//
//   /// Get FCM token from local storage
//   Future<String?> getFCMTokenFromStorage() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString('fcm_token');
//     } catch (e) {
//       print('❌ FCM Service - Failed to get FCM token from storage: $e');
//       return null;
//     }
//   }
//
//   /// Configure message handlers for background and foreground
//   void configureMessageHandlers() {
//     print('🔔 FCM Service - Configuring message handlers...');
//
//     // Handle messages when app is in foreground
//     FirebaseMessaging.onMessage.listen(handleForegroundMessage);
//
//     // Handle messages when app is opened from background
//     FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage);
//
//     // Handle messages when app is opened from terminated state
//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message != null) {
//         handleTerminatedMessage(message);
//       }
//     });
//
//     // Listen for token refresh
//     _firebaseMessaging.onTokenRefresh.listen((newToken) {
//       fcmToken.value = newToken;
//       saveFCMTokenToStorage(newToken);
//       print('🔄 FCM Service - Token refreshed: ${newToken.substring(0, 20)}...');
//       // TODO: Send new token to server
//     });
//
//     print('✅ FCM Service - Message handlers configured');
//   }
//
//   /// Handle foreground messages
//   Future<void> handleForegroundMessage(RemoteMessage message) async {
//     print('🔔 FCM Service - Foreground message received: ${message.messageId}');
//     print('🔔 FCM Service - Message data: ${message.data}');
//     print('🔔 FCM Service - Message notification: ${message.notification?.title}');
//
//     // Show local notification for foreground messages
//     await showLocalNotification(message);
//
//     // Handle custom data if needed
//     handleMessageData(message.data);
//   }
//
//   /// Handle background messages (when app is opened from notification)
//   Future<void> handleBackgroundMessage(RemoteMessage message) async {
//     print('🔔 FCM Service - Background message received: ${message.messageId}');
//     print('🔔 FCM Service - Message data: ${message.data}');
//
//     // Handle custom data
//     handleMessageData(message.data);
//
//     // Navigate to specific screen if needed
//     handleNavigation(message.data);
//   }
//
//   /// Handle terminated messages (when app is opened from notification)
//   Future<void> handleTerminatedMessage(RemoteMessage message) async {
//     print('🔔 FCM Service - Terminated message received: ${message.messageId}');
//     print('🔔 FCM Service - Message data: ${message.data}');
//
//     // Handle custom data
//     handleMessageData(message.data);
//
//     // Navigate to specific screen if needed
//     handleNavigation(message.data);
//   }
//
//   /// Show local notification
//   Future<void> showLocalNotification(RemoteMessage message) async {
//     try {
//       final notification = message.notification;
//       if (notification == null) return;
//
//       const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//         _channelId,
//         _channelName,
//         channelDescription: _channelDescription,
//         importance: Importance.high,
//         priority: Priority.high,
//         showWhen: true,
//         enableVibration: true,
//         playSound: true,
//         icon: '@mipmap/ic_launcher',
//       );
//
//       const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       );
//
//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       );
//
//       await _localNotifications.show(
//         message.hashCode,
//         notification.title,
//         notification.body,
//         notificationDetails,
//         payload: message.data.toString(),
//       );
//
//       print('✅ FCM Service - Local notification shown');
//
//     } catch (e) {
//       print('❌ FCM Service - Failed to show local notification: $e');
//     }
//   }
//
//   /// Handle notification tap
//   void onNotificationTapped(NotificationResponse response) {
//     print('🔔 FCM Service - Notification tapped: ${response.payload}');
//
//     // Parse payload and handle navigation
//     if (response.payload != null) {
//       // TODO: Parse payload and navigate to specific screen
//       handleNotificationTap(response.payload!);
//     }
//   }
//
//   /// Handle notification tap with payload
//   void handleNotificationTap(String payload) {
//     try {
//       // Parse payload and navigate accordingly
//       // This is where you'd implement navigation logic based on notification data
//       print('🔔 FCM Service - Handling notification tap with payload: $payload');
//
//       // Example: Navigate to specific screen based on notification type
//       // Get.toNamed('/notification-screen', arguments: payload);
//
//     } catch (e) {
//       print('❌ FCM Service - Failed to handle notification tap: $e');
//     }
//   }
//
//   /// Handle message data
//   void handleMessageData(Map<String, dynamic> data) {
//     try {
//       print('🔔 FCM Service - Handling message data: $data');
//
//       // Process custom data from notification
//       // Example: Update app state, show in-app notifications, etc.
//
//     } catch (e) {
//       print('❌ FCM Service - Failed to handle message data: $e');
//     }
//   }
//
//   /// Handle navigation based on message data
//   void handleNavigation(Map<String, dynamic> data) {
//     try {
//       print('🔔 FCM Service - Handling navigation with data: $data');
//
//       // Navigate to specific screen based on notification data
//       // Example:
//       // if (data['type'] == 'approval') {
//       //   Get.toNamed('/approvals');
//       // } else if (data['type'] == 'request') {
//       //   Get.toNamed('/requests');
//       // }
//
//     } catch (e) {
//       print('❌ FCM Service - Failed to handle navigation: $e');
//     }
//   }
//
//   /// Subscribe to topic
//   Future<void> subscribeToTopic(String topic) async {
//     try {
//       await _firebaseMessaging.subscribeToTopic(topic);
//       print('✅ FCM Service - Subscribed to topic: $topic');
//     } catch (e) {
//       print('❌ FCM Service - Failed to subscribe to topic $topic: $e');
//     }
//   }
//
//   /// Unsubscribe from topic
//   Future<void> unsubscribeFromTopic(String topic) async {
//     try {
//       await _firebaseMessaging.unsubscribeFromTopic(topic);
//       print('✅ FCM Service - Unsubscribed from topic: $topic');
//     } catch (e) {
//       print('❌ FCM Service - Failed to unsubscribe from topic $topic: $e');
//     }
//   }
//
//   /// Get device info for FCM token registration
//   Future<Map<String, dynamic>> getDeviceInfo() async {
//     try {
//       final deviceInfo = DeviceInfoPlugin();
//
//       if (Platform.isAndroid) {
//         final androidInfo = await deviceInfo.androidInfo;
//         return {
//           'platform': 'android',
//           'deviceId': androidInfo.id,
//           'model': androidInfo.model,
//           'brand': androidInfo.brand,
//           'version': androidInfo.version.release,
//           'sdkInt': androidInfo.version.sdkInt,
//         };
//       } else if (Platform.isIOS) {
//         final iosInfo = await deviceInfo.iosInfo;
//         return {
//           'platform': 'ios',
//           'deviceId': iosInfo.identifierForVendor,
//           'model': iosInfo.model,
//           'name': iosInfo.name,
//           'version': iosInfo.systemVersion,
//         };
//       }
//
//       return {'platform': 'unknown'};
//     } catch (e) {
//       print('❌ FCM Service - Failed to get device info: $e');
//       return {'platform': 'unknown', 'error': e.toString()};
//     }
//   }
//
//   /// Clear all notifications
//   Future<void> clearAllNotifications() async {
//     try {
//       await _localNotifications.cancelAll();
//       print('✅ FCM Service - All notifications cleared');
//     } catch (e) {
//       print('❌ FCM Service - Failed to clear notifications: $e');
//     }
//   }
//
//   /// Check if notifications are enabled
//   Future<bool> areNotificationsEnabled() async {
//     try {
//       final settings = await _firebaseMessaging.getNotificationSettings();
//       return settings.authorizationStatus == AuthorizationStatus.authorized;
//     } catch (e) {
//       print('❌ FCM Service - Failed to check notification status: $e');
//       return false;
//     }
//   }
//
//   /// Request permission again
//   Future<bool> requestPermissionAgain() async {
//     try {
//       await requestNotificationPermissions();
//       return hasPermission.value;
//     } catch (e) {
//       print('❌ FCM Service - Failed to request permission again: $e');
//       return false;
//     }
//   }
// }
//
// /// Top-level function to handle background messages
// /// This function must be at the top level (not inside a class)
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('🔔 Background Handler - Message received: ${message.messageId}');
//   print('🔔 Background Handler - Message data: ${message.data}');
//
//   // Initialize Firebase if not already initialized
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp();
//   }
//
//   // Handle background message processing here
//   // Note: This runs in a separate isolate, so you can't use GetX or other app state
// }
