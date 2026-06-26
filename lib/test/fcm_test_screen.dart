// Test file to verify FCM service integration
// This file can be deleted after testing

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eztrack_rental/services/fcm_service.dart';
import 'package:eztrack_rental/widgets/notification_helper.dart';

class FCMTestScreen extends StatelessWidget {
  const FCMTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Test Screen'),
        actions: const [
          // NotificationStatusWidget(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: [
        //     const Text(
        //       'Firebase Cloud Messaging Test',
        //       style: TextStyle(
        //         fontSize: 24,
        //         fontWeight: FontWeight.bold,
        //       ),
        //       textAlign: TextAlign.center,
        //     ),
        //     const SizedBox(height: 20),
        //
        //     // FCM Status
        //     Obx(() {
        //       final fcmService = FCMService.to;
        //       return Card(
        //         child: Padding(
        //           padding: const EdgeInsets.all(16.0),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               const Text(
        //                 'FCM Service Status',
        //                 style: TextStyle(
        //                   fontSize: 18,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               const SizedBox(height: 10),
        //               Row(
        //                 children: [
        //                   Icon(
        //                     fcmService.isInitialized.value
        //                         ? Icons.check_circle
        //                         : Icons.error,
        //                     color: fcmService.isInitialized.value
        //                         ? Colors.green
        //                         : Colors.red,
        //                   ),
        //                   const SizedBox(width: 8),
        //                   Text(
        //                     fcmService.isInitialized.value
        //                         ? 'Initialized'
        //                         : 'Not Initialized',
        //                     style: TextStyle(
        //                       color: fcmService.isInitialized.value
        //                           ? Colors.green
        //                           : Colors.red,
        //                       fontWeight: FontWeight.w500,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               const SizedBox(height: 8),
        //               Row(
        //                 children: [
        //                   Icon(
        //                     fcmService.hasPermission.value
        //                         ? Icons.check_circle
        //                         : Icons.error,
        //                     color: fcmService.hasPermission.value
        //                         ? Colors.green
        //                         : Colors.red,
        //                   ),
        //                   const SizedBox(width: 8),
        //                   Text(
        //                     fcmService.hasPermission.value
        //                         ? 'Permissions Granted'
        //                         : 'Permissions Denied',
        //                     style: TextStyle(
        //                       color: fcmService.hasPermission.value
        //                           ? Colors.green
        //                           : Colors.red,
        //                       fontWeight: FontWeight.w500,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               const SizedBox(height: 8),
        //               Text(
        //                 'Token: ${fcmService.fcmToken.value.isNotEmpty
        //                     ? "${fcmService.fcmToken.value.substring(0, 20)}..."
        //                     : "Not Available"}',
        //                 style: const TextStyle(
        //                   fontSize: 12,
        //                   fontFamily: 'monospace',
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       );
        //     }),
        //
        //     const SizedBox(height: 20),
        //
        //     // Test Buttons
        //     ElevatedButton.icon(
        //       onPressed: NotificationHelper.showTestNotification,
        //       icon: const Icon(Icons.notifications),
        //       label: const Text('Test Notification'),
        //     ),
        //
        //     const SizedBox(height: 10),
        //
        //     ElevatedButton.icon(
        //       onPressed: NotificationHelper.showFCMToken,
        //       icon: const Icon(Icons.copy),
        //       label: const Text('Show FCM Token'),
        //     ),
        //
        //     const SizedBox(height: 10),
        //
        //     ElevatedButton.icon(
        //       onPressed: NotificationHelper.checkNotificationPermissions,
        //       icon: const Icon(Icons.security),
        //       label: const Text('Check Permissions'),
        //     ),
        //
        //     const SizedBox(height: 10),
        //
        //     ElevatedButton.icon(
        //       onPressed: NotificationHelper.requestNotificationPermissions,
        //       icon: const Icon(Icons.request_page),
        //       label: const Text('Request Permissions'),
        //     ),
        //
        //     const SizedBox(height: 10),
        //
        //     ElevatedButton.icon(
        //       onPressed: NotificationHelper.showNotificationSettings,
        //       icon: const Icon(Icons.settings),
        //       label: const Text('Notification Settings'),
        //     ),
        //
        //     const SizedBox(height: 20),
        //
        //     // Debug Panel
        //     const DebugNotificationPanel(),
        //   ],
        // ),
      ),
    );
  }
}
