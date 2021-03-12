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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text('Privacy Policy'),
                    subtitle: Text(
                        'We are unethical. You have no privacy. muahahaha'),
                  ),
                  ListTile(
                    title: Text('Copyright Info'),
                    subtitle: Text(
                        'This app was created by:\nJames Chartaw\nRajesh Dhirar\nRudy Fisher\nDylan Schulz\nMike Schommer'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
