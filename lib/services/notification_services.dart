import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo/ui/screens/notification_screen.dart';

import '/models/task.dart';

class NotifyHelper {
  NotifyHelper._();
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static String selectedNotificationPayload = '';

  static final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();
  static Future<void> initializeNotification() async {
    tz.initializeTimeZones();
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();
    // await requestIOSPermissions(flutterLocalNotificationsPlugin);
    const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('appicon');

    const InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload!);
      },
    );
  }

  static void displayNotification({required String title, required String body}) async {
    var androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('your channel id', 'your channel name', channelDescription: 'your channel description', importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  static void scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.body,
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      _nextInstanceOfTenAM(hour, minutes, task.remind!, task.repeat!, task.date!),
      const NotificationDetails(
        android: AndroidNotificationDetails('your channel id', 'your channel name', channelDescription: 'your channel description'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.body}|${task.startTime}|',
    );
  }

  static tz.TZDateTime _nextInstanceOfTenAM(int hour, int minutes, int remind, String repeat, String date) {
    //
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    final dateTime = DateFormat.yMd().parse(date);

    final tz.TZDateTime dateTimeZoned = tz.TZDateTime.from(dateTime, tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, dateTimeZoned.year, dateTimeZoned.month, dateTimeZoned.day, hour, minutes);

    if (scheduledDate.isBefore(now)) {
      if (repeat == 'Daily') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, dateTime.day + 1, hour, minutes);
      }
      if (repeat == 'Weekly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, dateTime.day + 7, hour, minutes);
      }
      if (repeat == 'Monthly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, dateTime.month + 1, dateTime.day, hour, minutes);
      }
    }
    scheduledDate = scheduledDate.subtract(Duration(minutes: remind));
    return scheduledDate;
  }

  static void cancelNotification(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
  }

  static void cancelAllNotifications() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  static void requestIOSPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

/*   Future selectNotification(String? payload) async {
    if (payload != null) {
      //selectedNotificationPayload = "The best";
      selectNotificationSubject.add(payload);
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(() => SecondScreen(selectedNotificationPayload));
  } */

//Older IOS
  static Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    /* showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Title'),
        content: const Text('Body'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Container(color: Colors.white),
                ),
              );
            },
          )
        ],
      ),
    );
 */
    Get.dialog(Text(body!));
  }

  static void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      final title = payload.split('|').first;
      final date = payload.split('|')[1];
      final description = payload.split('|').last;
      await Get.to(() => NotificationScreen(taskName: title, date: date, description: description));
    });
  }
}
