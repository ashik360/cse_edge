import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // 1. Request Permission
    NotificationSettings permissionSettings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (permissionSettings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted notification permission');
    }

    // 2. Setup Android Initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(
      settings: initializationSettings, 
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log("Notification clicked: ${response.payload}");
      },
    );

    // 3. Get Device Token (With robust error handling)
    try {
      await Future.delayed(const Duration(milliseconds: 500)); 
      
      String? token = await _messaging.getToken();
      
      print("🔥 ======================================== 🔥");
      print("FCM TOKEN: $token");
      print("🔥 ======================================== 🔥");
      
    } catch (e) {
      print("❌ ======================================== ❌");
      print("FAILED TO GET FCM TOKEN: $e");
      print("❌ ======================================== ❌");
    }

    // 4. Handle Foreground/Background listeners
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Message received in foreground: ${message.notification?.title}");
      _showLocalNotification(message);
    });
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    log("Handling a background message: ${message.messageId}");
  }

  static void _showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'cse_edge_updates',      // id
      'CSE Edge Content Updates', // name
      channelDescription: 'Notifications for new notes and exam updates',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher', // Explicitly added to prevent lookup fails
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
    );

    _localNotifications.show(
      id: message.hashCode, 
      title: message.notification?.title ?? 'New Update',
      body: message.notification?.body ?? 'Check your semester dashboard',
      notificationDetails: platformChannelSpecifics,
    );
  }

  static Future<void> subscribeToCourse(String courseCode) async {
    String topic = courseCode.toLowerCase().replaceAll(' ', '_');
    await _messaging.subscribeToTopic(topic);
    log("Subscribed to topic: $topic");
  }

  // --- NEW: Method for safely testing local notifications ---
  static Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'cse_edge_test',
      'CSE Edge Test Updates',
      channelDescription: 'Testing local notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher', // Explicitly added to prevent lookup fails
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      id: 99, // Static ID for the test notification
      title: '🔥 Test: New CSE Note!',
      body: 'Someone just added a recursion sheet for CSE 101.',
      notificationDetails: platformChannelSpecifics,
    );
  }
}