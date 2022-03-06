import 'package:curiosity_flutter/const/notification_id.dart';
import 'package:curiosity_flutter/const/notification_payload.dart';
import 'package:curiosity_flutter/services/log_service.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
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

  // Triggered at 12AM PST
  // Schedule activity reminder notification at 9AM PST everyday
  void scheduleSetupActivityNotification() async {
    try {
      log.infoObj({'method': 'scheduleSetupActivityNotification'});
      // Notification pops up every hour
      await flutterLocalNotificationsPlugin.periodicallyShow(
          DailyActivitySetupReminderId,
          'Activity Setup reminder',
          'Please setup your activity for the day',
          RepeatInterval.hourly,
          platformChannelSpecifics,
          androidAllowWhileIdle: true,
          payload: NotificationPayload.DailyActivitySetup.toString());
      log.successObj({'method': 'scheduleSetupActivityNotification - success'});
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
          .cancel(DailyActivitySetupReminderId);
      log.successObj({'method': 'cancelSetupActivityNotification - success'});
    } catch (error) {
      log.errorObj({
        'method': 'scheduleSetupActivityNotification - error',
        'error': error
      }, 1);
    }
  }

  // Trigger at 12AM PST
  // Scheduling the notification to remind the user to complete their mindfulness
  // session
  void scheduleMindfulnessSessionNotification() async {
    try {
      log.infoObj({'method': 'scheduleMindfulnessActivityNotification'});
      dynamic mindfulnessNotiTimes =
          (await userDbService.getMindfulNotiPref())['mindfulReminders'];
      // The notification id for each mindfulness notification id is between
      // 1 - 5 [inclusive] [8, 9, 10, 11, 12]
      for (int i = 0; i < mindfulnessNotiTimes.length; i++) {
        flutterLocalNotificationsPlugin.zonedSchedule(
            i + 1,
            'Complete your mindfulness session',
            'Please finish your mindfulness session for the day',
            tz.TZDateTime.now(tz.local)
                .add(Duration(hours: mindfulnessNotiTimes[i])),
            platformChannelSpecifics,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: NotificationPayload.MindfulnessSession.toString());
      }

      log.successObj(
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
      for (int pos = 0; pos < MindfulnessReminderIds.length; pos++) {
        await flutterLocalNotificationsPlugin
            .cancel(MindfulnessReminderIds[pos]);
      }
      log.successObj({'method': 'cancelMindfulSessionNotification - success'});
    } catch (error) {
      log.errorObj({
        'method': 'cancelMindfulSessionNotification - error',
        'error': error
      }, 1);
    }
  }

  // Scheduling notification to reminder the user to complete their daily activity
  // startTime format (HH:MM)
  void scheduleActivityCompletionNotification(String startTime) async {
    try {
      log.infoObj({'method': 'scheduleActivityCompletionNotification'});

      // Calculating how many notification the program needs to setup for the day
      int numNotifications = calcDiffBetweenTimes(startTime, '23:59').inHours;
      // Calculating the difference between the current local time and the time
      // the user wants to start getting reminders
      String crntLocalString =
          tz.TZDateTime.now(tz.local).toString().split(" ")[1].substring(0, 5);
      int crntAndStartTimeMinDiff =
          calcDiffBetweenTimes(crntLocalString, startTime).inMinutes;

      log.infoObj({
        'method': 'scheduleActivityCompletionNotification',
        'crntAndStartTimeMinDiff': crntAndStartTimeMinDiff,
        'crntLocalString': crntLocalString,
        'numNotifications': numNotifications
      });

      // Scheduling the remainder of the notification for the day
      for (int pos = 0; pos < numNotifications + 1; pos++) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
            DailyActivityCompletionReminderIds[pos],
            'Daily Activity Reminder',
            'Reminder to complete your daily activity',
            tz.TZDateTime.now(tz.local)
                .add(Duration(seconds: crntAndStartTimeMinDiff + (60 * pos))),
            platformChannelSpecifics,
            androidAllowWhileIdle:
                true, // deliver notification for android while on low power
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
      }
      log.successObj(
          {'method': 'scheduleActivityCompletionNotification - success'});
    } catch (error) {
      log.errorObj({
        'method': 'scheduleActivityCompletionNotification - error',
        'error': error
      }, 2);
    }
  }

  // Removing all the mindfulness session notification
  void cancelActivityCompletionNotification() async {
    try {
      log.infoObj({'method': 'cancelActivityCompletionNotification'});
      // Removing all the mindfulness reminder notification
      for (int pos = 0;
          pos < DailyActivityCompletionReminderIds.length;
          pos++) {
        await flutterLocalNotificationsPlugin
            .cancel(DailyActivityCompletionReminderIds[pos]);
      }
      log.successObj({'method': 'cancelMindfulSessionNotification - success'});
    } catch (error) {
      log.errorObj({
        'method': 'cancelMindfulSessionNotification - error',
        'error': error
      }, 1);
    }
  }

  // Calculating the time difference between two times (format: HH:MM) and
  // return the difference as a duration object
  Duration calcDiffBetweenTimes(String t1, String t2) {
    DateFormat format = DateFormat("HH:mm");
    DateTime one = format.parse(t1);
    DateTime two = format.parse(t2);
    return two.difference(one);
  }
}
