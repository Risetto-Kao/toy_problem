import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String? payload;

  const SecondPage({Key? key,required this.payload}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(payload ?? 'no payload'),),
    );
  }
}