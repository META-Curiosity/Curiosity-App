import 'package:curiosity_flutter/const/notification_id.dart';
import 'package:curiosity_flutter/const/notification_payload.dart';
import 'package:curiosity_flutter/services/log_service.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class NotificationService {
  final LogService log = new LogService();
  UserDbService userDbService;
  NotificationDetails platformChannelSpecifics;

  NotificationService(String uuid) {
    userDbService = UserDbService(uuid);

    // Setting up the time zone - based in PST
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Los_Angeles'));

    // Setting up the notification details for Android and iOS
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'activity_reminder_id', 'Activity Reminder Channel',
            channelDescription: 'Activity Reminder activity',
            icon: 'codex_logo');
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
  }

// schedule activity reminder notification at 9AM PST everyday
  void scheduleSetupActivityNotification() async {
    try {
      log.infoObj({'method': 'scheduleSetupActivityNotification'});
      // Notification pops up every hour
      await flutterLocalNotificationsPlugin.periodicallyShow(
          NotificationId.DailyActivitiySetupReminder.index,
          'Activity Setup reminder',
          'Please setup your activity for the day',
          RepeatInterval.hourly,
          platformChannelSpecifics,
          androidAllowWhileIdle: true,
          payload: NotificationPayload.DailyActivitySetup.toString());
    } catch (error) {
      log.errorObj({
        'method': 'scheduleSetupActivityNotification - error',
        'error': error
      }, 1);
    }
  }

// Cancel the reminder to setup activity for the day
  void cancelSetupActivityNotification() async {
    try {
      log.infoObj({'method': 'cancelSetupActivityNotification'});
      await flutterLocalNotificationsPlugin
          .cancel(NotificationId.DailyActivitiySetupReminder.index);
      log.infoObj({'method': 'cancelSetupActivityNotification - success'});
    } catch (error) {
      log.errorObj({
        'method': 'scheduleSetupActivityNotification - error',
        'error': error
      }, 1);
    }
  }

  // Scheduling the notification to remind the user to complete their mindfulness
  // session - called everyday at 12AM
  void scheduleMindfulnessSessionNotification() async {
    try {
      log.infoObj({'method': 'scheduleMindfulnessActivityNotification'});
      dynamic mindfulnessNotiTimes =
          (await userDbService.getMindfulNotiPref())['mindfulReminders'];
      // The notification id for each mindfulness notification id is between
      // 1 - 5 [inclusive]
      for (int i = 0; i < mindfulnessNotiTimes.length; i++) {
        flutterLocalNotificationsPlugin.zonedSchedule(
            i + 1,
            'Complete your mindfulness session',
            'Please finish your mindfulness session for the day',
            tz.TZDateTime.now(tz.local)
                .add(Duration(seconds: mindfulnessNotiTimes[i])),
            platformChannelSpecifics,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: NotificationPayload.MindfulnessSession.toString());
      }

      log.infoObj(
          {'method': 'scheduleMindfulnessActivityNotification - success'});
    } catch (error) {
      log.errorObj({
        'method': 'scheduleMindfulnessActivityNotification - error',
        'error': error
      }, 1);
    }
  }

  // Removing all the mindfulness session notification
  void cancelMindfulSessionNotification() async {
    try {
      log.infoObj({'method': 'cancelMindfulSessionNotification'});

      // Removing all the mindfulness reminder notification
      flutterLocalNotificationsPlugin
          .cancel(NotificationId.MindfulnessReminder1.index);
      flutterLocalNotificationsPlugin
          .cancel(NotificationId.MindfulnessReminder2.index);
      flutterLocalNotificationsPlugin
          .cancel(NotificationId.MindfulnessReminder3.index);
      flutterLocalNotificationsPlugin
          .cancel(NotificationId.MindfulnessReminder4.index);
      flutterLocalNotificationsPlugin
          .cancel(NotificationId.MindfulnessReminder5.index);

      log.infoObj({'method': 'cancelMindfulSessionNotification - success'});
    } catch (error) {
      log.errorObj({
        'method': 'cancelMindfulSessionNotification - error',
        'error': error
      }, 1);
    }
  }
}
