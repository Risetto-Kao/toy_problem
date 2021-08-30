import 'package:flutter/material.dart';
import 'package:local_notification/api/notification_api.dart';
import 'package:local_notification/second_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    NotificationApi.init(initScheduled: true);
    listenNotifications();

    // NotificationApi.scheduleNotification(
    //   id: 0,
    //   title: 'test title',
    //   body: 'test body',
    //   payload: 'test payload',
    //   scheduledDate: DateTime.now().add(Duration(seconds: 12)),
    // );
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickNotification);

  void onClickNotification(String? paylod) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SecondPage(payload: paylod),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              NotificationApi.showNotification(
                  id: 1,
                  title: 'test title',
                  body: 'test body',
                  payload: 'test payload');
            },
            child: Text('simple notificaiton'),
          ),
          TextButton(
            onPressed: () {
              NotificationApi.scheduleNotification(
                id: 2,
                title: 'dinner',
                body: 'dinner body',
                payload: 'dinner payload',
                scheduledDateTime: DateTime(2021,1)
               
              );
            },
            child: Text('scheduled notification'),
          ),
          TextButton(
            onPressed: () {},
            child: Text('remove notification'),
          ),
        ],
      ),
    );
  }
}
