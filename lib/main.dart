import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_widget.dart';

///The intry point of the app
void main() {
  runApp(ChangeNotifierProvider(
    child: RootWidget(),
    create: (context) => null,
  ));
}

///The root of the app
class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SuperSchedulerApp(),
    );
  }
}
