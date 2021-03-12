import 'package:flutter/material.dart';

class NotificationsWidget extends StatefulWidget {
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  final userNotifications = [
    'tmp',
    'tmp',
    'tmp',
    'tmp',
    'tmp',
    'tmp',
    'tmp',
    'tmp',
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: userNotifications.length,
        itemBuilder: (BuildContext context, int index) => ListTile(
          leading: Icon(Icons.notification_important_rounded),
          title: Text(
            userNotifications[index],
          ),
          subtitle: Text(
            userNotifications[index],
          ),
          trailing: IconButton(
              icon: Icon(Icons.delete_forever_rounded), onPressed: null),
        ),
        separatorBuilder: (context, index) => Divider(
          height: 16.0,
        ),
      ),
    );
  }
}

//TODO: define a class for notifications with optional buttons
