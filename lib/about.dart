import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

///Defines the app's about screen
///@author: Rudy Fisher
class AboutWidget extends StatelessWidget {
  final double margin = 16.0;
  final String privacyPolicyUrl =
      'https://docs.google.com/document/d/10VCnZkIwAFCfP_fG73n66pcr5tdcet8aKNhaD-Cz09E/edit?usp=sharing';

  Future<void> _launchInBrowser() async {
    try {
      if (await canLaunch(privacyPolicyUrl)) {
        await launch(
          privacyPolicyUrl,
          forceSafariVC: true,
          forceWebView: true,
        );
      } else {
        throw 'Could not launch $privacyPolicyUrl';
      }
    } catch (e) {
      print(e);
    }
  }

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
                    title: TextButton(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Privacy Policy',
                        ),
                      ),
                      onPressed: _launchInBrowser,
                    ),
                    subtitle: Text('Tap above to open on the web. Use device back button to return.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.copyright_rounded),
                    title: Text('Copyright Info'),
                    subtitle: Text(
                        'This app was created by:\n\tJames Chartaw\n\tRajesh Dhirar\n\tRudy Fisher\n\tDylan Schulz\n\tMike Schommer'),
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
