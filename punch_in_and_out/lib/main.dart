import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Punch In & Out'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[700],
      appBar: AppBar(
          title: Center(
            child: Text(
              widget.title,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          backgroundColor: Colors.transparent),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.white),
            ),
            flex: 7,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.lightBlue[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 80,
                    onPressed: null,
                    icon: Icon(
                      Icons.flag,
                      color: Colors.green[600],
                    ),
                  ),
                  IconButton(
                    hoverColor: Colors.blue,
                    iconSize: 80,
                    onPressed: null,
                    icon: Icon(
                      Icons.bedtime,
                      color: Colors.amber[300],
                      semanticLabel: 'Punch Out',
                    ),
                  ),
                ],
              ),
            ),
            flex: 3,
          ),
        ],
      ),
    );
  }
}
