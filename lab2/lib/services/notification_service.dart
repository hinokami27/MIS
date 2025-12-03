import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Skopje'));
  }

  Future<void> requestPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 10, 0, 0);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfTwoMinutes() {
    return tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));
  }

  Future<void> scheduleDailyRecipeNotification() async {

    const int id = 0;
    const String title = '✅ ТЕСТ: Успешно закажување!';
    const String body = 'Ова е статична нотификација закажана 2 минути од сега.';

    final tz.TZDateTime scheduledDate = _nextInstanceOfTwoMinutes();

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_recipe_channel_id',
            'Дневни Рецепти',
            channelDescription: 'Дневни нотификации за случајни рецепти',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
      print('Notification scheduled for testing at ${scheduledDate.hour}:${scheduledDate.minute}:${scheduledDate.second} using AndroidScheduleMode.exact.');
    } on PlatformException catch (e) {
      print('Platform Error during notification scheduling: ${e.message}');
    }
  }
}