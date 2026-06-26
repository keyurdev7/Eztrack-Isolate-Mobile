// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:eztrack_rental/services/fcm_service.dart';
//
// class NotificationHelper {
//   /// Show a test notification
//   static Future<void> showTestNotification() async {
//     try {
//       final fcmService = FCMService.to;
//       if (fcmService.isInitialized.value) {
//         // This would typically be sent from your server
//         // For testing, you can use Firebase Console to send a test message
//         Get.snackbar(
//           'Test Notification',
//           'FCM Service is initialized and ready to receive notifications',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 3),
//         );
//       } else {
//         Get.snackbar(
//           'FCM Not Ready',
//           'FCM Service is not initialized yet',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 3),
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to test notifications: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//     }
//   }
//
//   /// Show FCM token for debugging
//   static void showFCMToken() {
//     try {
//       final fcmService = FCMService.to;
//       final token = fcmService.fcmToken.value;
//
//       if (token.isNotEmpty) {
//         Get.dialog(
//           AlertDialog(
//             title: const Text('FCM Token'),
//             content: SelectableText(
//               token,
//               style: const TextStyle(fontSize: 12),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Get.back(),
//                 child: const Text('Close'),
//               ),
//             ],
//           ),
//         );
//       } else {
//         Get.snackbar(
//           'No Token',
//           'FCM token is not available yet',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to get FCM token: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   /// Check notification permissions
//   static Future<void> checkNotificationPermissions() async {
//     try {
//       final fcmService = FCMService.to;
//       final hasPermission = await fcmService.areNotificationsEnabled();
//
//       Get.snackbar(
//         'Notification Status',
//         hasPermission ? 'Notifications are enabled' : 'Notifications are disabled',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: hasPermission ? Colors.green : Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to check notification permissions: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   /// Request notification permissions
//   static Future<void> requestNotificationPermissions() async {
//     try {
//       final fcmService = FCMService.to;
//       final granted = await fcmService.requestPermissionAgain();
//
//       Get.snackbar(
//         'Permission Request',
//         granted ? 'Notification permissions granted' : 'Notification permissions denied',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: granted ? Colors.green : Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to request notification permissions: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   /// Clear all notifications
//   static Future<void> clearAllNotifications() async {
//     try {
//       final fcmService = FCMService.to;
//       await fcmService.clearAllNotifications();
//
//       Get.snackbar(
//         'Notifications Cleared',
//         'All notifications have been cleared',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.blue,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to clear notifications: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   /// Show notification settings dialog
//   static void showNotificationSettings() {
//     Get.dialog(
//       AlertDialog(
//         title: const Text('Notification Settings'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Obx(() {
//               final fcmService = FCMService.to;
//               return ListTile(
//                 leading: Icon(
//                   fcmService.hasPermission.value ? Icons.notifications : Icons.notifications_off,
//                   color: fcmService.hasPermission.value ? Colors.green : Colors.red,
//                 ),
//                 title: const Text('Push Notifications'),
//                 subtitle: Text(
//                   fcmService.hasPermission.value ? 'Enabled' : 'Disabled',
//                 ),
//                 trailing: Switch(
//                   value: fcmService.hasPermission.value,
//                   onChanged: (value) {
//                     if (value) {
//                       requestNotificationPermissions();
//                     }
//                   },
//                 ),
//               );
//             }),
//             const Divider(),
//             ListTile(
//               leading: const Icon(Icons.info_outline),
//               title: const Text('FCM Status'),
//               subtitle: Obx(() {
//                 final fcmService = FCMService.to;
//                 return Text(
//                   fcmService.isInitialized.value ? 'Initialized' : 'Not Initialized',
//                 );
//               }),
//               onTap: showFCMToken,
//             ),
//             ListTile(
//               leading: const Icon(Icons.clear_all),
//               title: const Text('Clear All Notifications'),
//               onTap: () {
//                 Get.back();
//                 clearAllNotifications();
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Notification status widget for debugging
// class NotificationStatusWidget extends StatelessWidget {
//   const NotificationStatusWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final fcmService = FCMService.to;
//       return Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: fcmService.isInitialized.value ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: fcmService.isInitialized.value ? Colors.green : Colors.red,
//             width: 1,
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               fcmService.isInitialized.value ? Icons.notifications_active : Icons.notifications_off,
//               color: fcmService.isInitialized.value ? Colors.green : Colors.red,
//               size: 16,
//             ),
//             const SizedBox(width: 4),
//             Text(
//               fcmService.isInitialized.value ? 'FCM Ready' : 'FCM Not Ready',
//               style: TextStyle(
//                 color: fcmService.isInitialized.value ? Colors.green : Colors.red,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
//
// /// Debug notification panel
// class DebugNotificationPanel extends StatelessWidget {
//   const DebugNotificationPanel({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Notification Debug Panel',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Obx(() {
//               final fcmService = FCMService.to;
//               return Column(
//                 children: [
//                   Row(
//                     children: [
//                       const Text('FCM Status: '),
//                       Icon(
//                         fcmService.isInitialized.value ? Icons.check_circle : Icons.error,
//                         color: fcmService.isInitialized.value ? Colors.green : Colors.red,
//                         size: 16,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         fcmService.isInitialized.value ? 'Initialized' : 'Not Initialized',
//                         style: TextStyle(
//                           color: fcmService.isInitialized.value ? Colors.green : Colors.red,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       const Text('Permissions: '),
//                       Icon(
//                         fcmService.hasPermission.value ? Icons.check_circle : Icons.error,
//                         color: fcmService.hasPermission.value ? Colors.green : Colors.red,
//                         size: 16,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         fcmService.hasPermission.value ? 'Granted' : 'Denied',
//                         style: TextStyle(
//                           color: fcmService.hasPermission.value ? Colors.green : Colors.red,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       const Text('Token: '),
//                       Expanded(
//                         child: Text(
//                           fcmService.fcmToken.value.isNotEmpty
//                               ? '${fcmService.fcmToken.value.substring(0, 20)}...'
//                               : 'Not Available',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontFamily: 'monospace',
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               );
//             }),
//             const SizedBox(height: 16),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: NotificationHelper.showTestNotification,
//                   icon: const Icon(Icons.notifications, size: 16),
//                   label: const Text('Test'),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: NotificationHelper.showFCMToken,
//                   icon: const Icon(Icons.copy, size: 16),
//                   label: const Text('Show Token'),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: NotificationHelper.checkNotificationPermissions,
//                   icon: const Icon(Icons.security, size: 16),
//                   label: const Text('Check Perms'),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: NotificationHelper.requestNotificationPermissions,
//                   icon: const Icon(Icons.request_page, size: 16),
//                   label: const Text('Request'),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: NotificationHelper.clearAllNotifications,
//                   icon: const Icon(Icons.clear_all, size: 16),
//                   label: const Text('Clear'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
