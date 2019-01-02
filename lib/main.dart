import 'package:flutter/material.dart';
import './excuses.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Programmer excuses',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Excuses(),
    );
  }
}

