// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
//
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();
//
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> init() async {
//     await _fcm.requestPermission();
//
//     final fcmToken = await _fcm.getToken();
//     debugPrint("FCM Token: $fcmToken");
//
//     // Local Notification init
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const ios = DarwinInitializationSettings();
//     const initSettings = InitializationSettings(android: android, iOS: ios);
//     await _localNotifications.initialize(initSettings);
//
//     FirebaseMessaging.onMessage.listen(_handleForegroundNotification);
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
//
//   void _handleForegroundNotification(RemoteMessage message) {
//     final notification = message.notification;
//     if (notification != null) {
//       _localNotifications.show(
//         message.hashCode,
//         notification.title,
//         notification.body,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'default_channel',
//             'Default',
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//           iOS: DarwinNotificationDetails(),
//         ),
//       );
//     }
//   }
// }
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint("Background Message: ${message.notification?.title}");
// }
