import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:water_notification/utilities.dart';

Future<void> createPlantFoodNotification() async {
  ///  Can use [createNotificationFromJsonData]
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: '${Emojis.money_money_bag + Emojis.plant_cactus}',
        body: 'Florist at 123 Main St. has 2 in stock',

        ///  [NotificationLayOut] has some useful layout of notificiation, like prograssbar / media...
        notificationLayout: NotificationLayout.BigPicture),
  );
}

Future<void> createWaterReminderNotification(
    NotificationWeekAndTime notificationWeekAndTime) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 2,
      channelKey: 'scheduled_channel',
      title: '${Emojis.wheater_droplet} Add some water to your plant!',
      body: 'Water your plant regularly to keep it healthy.',
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      )
    ],
    schedule: NotificationCalendar(
      weekday: notificationWeekAndTime.dayOfTheWeek,
      hour: notificationWeekAndTime.timeOfDay.hour,
      minute: notificationWeekAndTime.timeOfDay.minute,
      second: 0,
      millisecond: 0,
      /// [repeats] can be true
    )
  );
}

Future<void> cancelCertainNotifications(int id) async{
  await AwesomeNotifications().cancel(id);
}

Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}