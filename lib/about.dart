import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

///Defines the app's about screen
///@author: Rudy Fisher
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
                    leading: Icon(Icons.privacy_tip_rounded),
                    title: Text('Privacy Policy'),
                    subtitle: Text(
                        'https://docs.google.com/document/d/10VCnZkIwAFCfP_fG73n66pcr5tdcet8aKNhaD-Cz09E/edit?usp=sharing'),
                  ),
                  ListTile(
                    leading: Icon(Icons.copyright_rounded),
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
