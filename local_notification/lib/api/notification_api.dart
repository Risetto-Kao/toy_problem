import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails(int id) async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id $id',
          'channel name',
          'channel description',
          importance: Importance.max,
        ),
        iOS: IOSNotificationDetails());
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails(id),
          payload: payload);

  static Future init({bool initScheduled = false}) async {
    final andoridSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOSSettings = IOSInitializationSettings();
    final initSettings =
        InitializationSettings(android: andoridSettings, iOS: iOSSettings);

    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp)
      onNotifications.add(details.payload);

    await _notifications.initialize(initSettings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDateTime
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          _scheduleDaily(scheduledDateTime),
          await _notificationDetails(id),
          payload: payload,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);

  static tz.TZDateTime _scheduleDaily(DateTime dateTime) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, dateTime.day,
        dateTime.hour, dateTime.minute, dateTime.second);
    // return scheduledDate.isBefore(now) ? scheduledDate.add(Duration(days: 1)): scheduledDate;
    return scheduledDate;
  }

  // static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}) {
  //   tz.TZDateTime scheduledDate = _scheduleDaily(time);

  //   while (!days.contains(scheduledDate.weekday)) {
  //     scheduledDate = scheduledDate.add(Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }

  static void cancel(int id) => _notifications.cancel(id);
  static void cancelAll() => _notifications.cancelAll();
}
