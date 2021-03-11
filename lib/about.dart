import 'package:flutter/material.dart';
import 'main.dart';

/* Screens:
 * About
 */

class AboutWidget extends StatelessWidget {
  final double margin = 16.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Container(
        padding: EdgeInsets.all(margin),
        child: Column(
          children: [
            Text('test'),
            Text('test'),
          ],
        ),
      ),
    );
  }
}
