import 'package:flutter/material.dart';
import 'drawer.dart';

/* Screens:
 * Notifications
 */

class NotificationsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Placeholder'),
    );
  }
}
