import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_widget.dart';

void main() {
  runApp(ChangeNotifierProvider(
    child: RootWidget(),
    create: (context) => null,
  ));
}

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
