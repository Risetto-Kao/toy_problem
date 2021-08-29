import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:water_notification/notifications.dart';
import 'package:water_notification/plant_state.dart';
import 'package:water_notification/utilities.dart';
import 'package:water_notification/widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Allow notifications'),
              content: Text('Need notification'),
              actions: [
                TextButton(
                  child: Text('Don\'t Allow'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text('Allow'),
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then(
                        (_) => Navigator.pop(context),
                      ),
                ),
              ],
            ),
          );
        }
      },
    );
    AwesomeNotifications().createdStream.listen(
      (notification) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('notification create on ${notification.channelKey}'),
          ),
        );
      },
    );
    AwesomeNotifications().actionStream.listen((action) {
      if (action.channelKey == 'basic_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
                  AwesomeNotifications().setGlobalBadgeCounter(value - 1),
            );
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => PlantStatsPage()),
          (route) => route.isFirst);
    },);
    /// [AwesomeNotifications().dismissStream] & [AwesomeNotifications().diplayStream] can be used

  }

  @override
  void dispose() {
    /// use what kind of stream, close that kind of sink
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppBarTitle(),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlantStatsPage(),
                ),
              );
            },
            icon: Icon(
              Icons.insert_chart_outlined_rounded,
              size: 30,
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlantImage(),
            SizedBox(
              height: 25,
            ),
            HomePageButtons(
              onPressedOne: createPlantFoodNotification,
              onPressedTwo: ()async{
                NotificationWeekAndTime? pickedSchedule = await pickSchedule(context);
                if (pickedSchedule != null) createWaterReminderNotification(pickedSchedule);
              },
              onPressedThree: ()async{
                await cancelCertainNotifications(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
