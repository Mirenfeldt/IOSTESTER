import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> scheduleNotification(int id, DateTime scheduleTime) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'basic_channel',
      title: 'Udfyld smertedagbog',
      body: 'Vurder smerteparametre ',
      wakeUpScreen: true,
      category: NotificationCategory.Reminder,
      notificationLayout: NotificationLayout.Default, // Use BigPicture layout
      //bigPicture: 'asset://Assets/20210715_135142.jpg', // Path to your image
      // importance: NotificationImportance.High, // Set importance to High
      // priority: NotificationPriority.Max, // Set priority to Max
      displayOnBackground: true,
      displayOnForeground: true,
    ),
    schedule: NotificationCalendar.fromDate(
        date: scheduleTime,
        repeats: true,
        preciseAlarm: true,
        allowWhileIdle: true),
  );
}
