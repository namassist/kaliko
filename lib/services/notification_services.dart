import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

// Background task callback
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      await Firebase.initializeApp();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final roomId = prefs.getString('room_id');

      if (userId != null && roomId != null) {
        final snapshot = await FirebaseDatabase.instance
            .ref()
            .child('controling')
            .child(roomId)
            .child('tanggal')
            .get();

        if (snapshot.exists) {
          final deadlineStr = snapshot.value as String;
          await NotificationService.checkAndShowNotification(deadlineStr,
              isBackground: true);
        }
      }
      return true;
    } catch (e) {
      rethrow;
    }
  });
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;
  static const String workManagerTaskName = 'checkDeadlineTask';

  // Initialize both foreground and background services
  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Request notification permission
    final status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }

    // Initialize local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );

    // Create notification channel
    await _createNotificationChannel();

    // Initialize background service
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().registerPeriodicTask(
      workManagerTaskName,
      workManagerTaskName,
      frequency: const Duration(hours: 12),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );

    _isInitialized = true;
  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'deadline_channel',
      'Payment Deadline',
      description: 'Notifications for payment deadlines',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> showDeadlineNotification(int daysRemaining) async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      return;
    }

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'deadline_channel',
      'Payment Deadline',
      channelDescription: 'Notifications for payment deadlines',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: const BigTextStyleInformation(''),
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      0,
      'Peringatan Pembayaran',
      'Segera lakukan pembayaran dalam $daysRemaining hari atau listrik kamar anda akan mati.',
      details,
      payload: 'deadline_notification',
    );
  }

  static Future<void> checkAndShowNotification(String deadlineStr,
      {bool isBackground = false}) async {
    try {
      final dueDate = DateFormat('dd/MM/yyyy').parse(deadlineStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dueDateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);
      final daysRemaining = dueDateOnly.difference(today).inDays;

      // Foreground notification only shows at H-3
      // Background notification shows at H-3, H-2, H-1
      if (!isBackground && daysRemaining <= 3 && daysRemaining > 0) {
        await showDeadlineNotification(daysRemaining);
      } else if (isBackground && (daysRemaining == 2 || daysRemaining == 1)) {
        await showDeadlineNotification(daysRemaining);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Methods for managing user session
  static Future<void> saveUserSession(String userId, String roomId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    await prefs.setString('room_id', roomId);
  }

  static Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('room_id');
  }
}
